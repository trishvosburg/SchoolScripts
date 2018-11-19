#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use List::Util 'uniq';
use Data::Dumper;

print_report();

# Load transcript IDs of query sequence (qseqid) and SwissProt IDs of subject sequence
# (sseqid) without version number to hash for lookup.
sub read_blast {

	# Hash to store BLAST mappings.
	my %transcript_to_protein;

	my $blast_file = '/scratch/RNASeq/blastp.outfmt6';
	open( BLAST, '<', $blast_file ) or die $!;

	# Read in the BLAST file, chomp each line, and then split each line on tabs.

	while ( my $line = <BLAST> ) {
		chomp $line;
		my @tab_split_blast         = split( /\t/, $line );
		my $untrimmed_transcript_id = $tab_split_blast[0];
		my $identity                = $tab_split_blast[2];
		my $transcript_id;
		my $protein_id;

		# Trim the transcriptID so it doesn't include the version number.
		if ( $untrimmed_transcript_id =~ m/^(c\d{1,4}_\w{1}\d{1}_\w{1}\d{1})/ )
		{
			$transcript_id = $1;
		}

		# Trim the protein ID column so it's only the protein ID.
		my $untrimmed_protein_id = $tab_split_blast[1];
		if ( $untrimmed_protein_id =~ m/sp\|(\w+)\./ ) {
			$protein_id = $1;
		}

	# If the identity is over 99, create a hash with transcriptID as the key and
	# proteinID as the value.
		if ( $identity > 99 ) {
			if ( $transcript_to_protein{$transcript_id} ) {
				next;
			}
			else {
				$transcript_to_protein{$transcript_id} = $protein_id // 'NA';
			}
		}
	}
	close BLAST;
	return \%transcript_to_protein;
}

# Print the hash to make sure it's correct:
# print Dumper(\%transcript_to_protein);

# Load protein IDs and corresponding GO terms to hash for lookup.
sub read_gene_to_GO {

	# Hash to store gene-to-GO term mappings.
	my %gene_to_GO;

	my $gene_to_GO_file = '/scratch/gene_association_subset.txt';
	open( GENE_TO_GO, '<', $gene_to_GO_file ) or die $!;

	# Read in the GO annotation file, chomp each line, split each line on tabs.
	while ( my $line = <GENE_TO_GO> ) {
		chomp $line;
		my @tab_split_gene = split( /\t/, $line );

		# Extract 2nd column which is the object ID.
		my $object_id = $tab_split_gene[1];

		# Extract the 4th column which is the GO ID.
		my $go_id = $tab_split_gene[4];

		# Create a hash with the object ID as the key and GO ID as the value.
		# If the object ID already exists,
		if ( $gene_to_GO{$object_id} ) {

			# push the $go_id from that line onto the GO ID array
			push( @{ $gene_to_GO{$object_id} }, $go_id );

		   # otherwise, create it in the hash with $go_id as an array reference.
		}
		else {
			$gene_to_GO{$object_id} = [$go_id] // 'NA';
		}
	}
	close GENE_TO_GO;
	return \%gene_to_GO;
}

# Print the hash to make sure it's correct:
# print Dumper(\%gene_to_GO);

# Load GO terms and GO descriptions to hash for lookup.
sub read_GO_desc {

	# Hash to store gene-to-GO term descriptions mappings.
	my %GO_to_description;

	my $GO_desc_file = '/scratch/go-basic.obo';
	open( GO_DESC, '<', $GO_desc_file ) or die $!;

# Change the EOL from "\n" to "[Term]" so that one entire GO term record will be read
# in for easier parsing.
	local $/ = '[Term]';

	# Read in the GO_desc file, chomp each line.
	while (<GO_DESC>) {
		chomp;

		# Use regex to extract just the GO Terms from the "id:" field.
		my $go_id_2 = $1 if /^id: (GO:[0-9]+)$/m;

		# Use regex to extract just the GO Names from the "name:" field.
		my $go_name = $1 if /^name: (.*)$/m;

		# Create a hash with GO Term as the key and GO Name as the value.
		$GO_to_description{$go_id_2} = $go_name if defined $go_id_2 // 'NA';

	}
	close GO_DESC;
	return \%GO_to_description;
}

# Loop through differential expression file; lookup the (SwissProt) protein ID + description
# and GO term + name; print results to REPORT output.
sub print_report {

	# Call other subroutines:
	my $GO_to_description     = read_GO_desc();
	my $transcript_to_protein = read_blast();
	my $gene_to_GO            = read_gene_to_GO();

	my $diff_exp_file = '/scratch/RNASeq/diffExpr.P1e-3_C2.matrix';

	# Open a filehandle for the Trinity output file.
	open( DIFF_EXP, '<', $diff_exp_file ) or die $!;

	my $report_file = 'report2.txt';

	# Open a filehandle to write the report.
	open( REPORT, '>', $report_file ) or die $!;
	
	# Read in Differential expression file, chomp each line, split it on tabs.
	while (<DIFF_EXP>) {
		chomp;
		
		# Create trinityID and 4 data samples variables for easier parsing.
		my ( $trinity_id, $sp_ds, $sp_hs, $sp_log, $sp_plat ) = split /\t/;

		#		my @tab_split_trinity = split( /\t/, $line );
		#		my $trinity_id        = $tab_split_trinity[0];
		#		my $sp_ds             = $tab_split_trinity[1];
		#		my $sp_hs             = $tab_split_trinity[2];
		#		my $sp_log            = $tab_split_trinity[3];
		#		my $sp_plat           = $tab_split_trinity[4];

		# Default variables to NA. If information in question is found in the file,
		# overrwrite the NA (otherwise, the NA remains as a placeholder of sorts).
		
		# Get the final protein ID by retrieving it from the transcript_to_protein hash:
		my $final_protein_id = $transcript_to_protein->{$trinity_id} // 'NA';

		# Check if protein ID is found in GENE_TO_GO hash reference, if it is:
		if ( defined $gene_to_GO->{$final_protein_id} ) {
			
			# get corresponding GO terms (in an array).
			my @final_GO_term = uniq @{ $gene_to_GO->{$final_protein_id} };
			
			# Set element counter to 0:
			my $ele_counter = 0;
			
			# Declare baseline for printing:
			my $base_line   = '';

			# Get the protein description by calling the appropriate subroutine:
			my $protein_description =
			  get_protein_info_from_blast_DB($final_protein_id);

			# For each GO id in the final_go_term array,
			foreach my $final_GO_id ( sort @final_GO_term ) {
				
				# Increase element counter:
				$ele_counter++;
				
				# get the corresponding GO description.
				my $final_GO_desc = $GO_to_description->{$final_GO_id} // 'NA';
	 
	 			# If the first element, include all this in the first line (baseline):
				if ( $ele_counter == 1 ) {
					$base_line = join( "\t",
						$trinity_id,  $sp_ds,
						$sp_hs,       $sp_log,
						$sp_plat,     $final_protein_id,
						$final_GO_id, $final_GO_desc,
						$protein_description );
				}
				# Otherwise, print the rest of the GO ids and GO descriptions indented:
				else {
					$base_line =
					    "\t \t \t \t \t \t"
					  . $final_GO_id . "\t"
					  . $final_GO_desc;
				}
				say REPORT $base_line;
			}
		}

  #	   # Check if the trinityID is in the %transcript_to_protein hash; if it is:
  #		if ( defined $transcript_to_protein->{$trinity_id} ) {
  #
  #			# get corresponding protein ID.
  #			my $final_protein_id = $transcript_to_protein->{$trinity_id};
  #
  #			my $protein_description =
  #			  get_protein_info_from_blast_DB($final_protein_id);
  #
  #		  # Check if protein ID is found in GENE_TO_GO hash reference, if it is:
  #			if ( defined $gene_to_GO->{$final_protein_id} ) {
  #
  #				# get corresponding GO terms (in an array).
  #				my @final_go_term = uniq @{ $gene_to_GO->{$final_protein_id} };
  #				my $ele_counter   = 0;
  #
  #				# For each element in the final_go_term array,
  #				foreach my $ele (@final_go_term) {
  #
  #					$ele_counter++;
  #
  #					# if the element is defined in the go_to_description hash:
  #					if ( defined $GO_to_description->{$ele} ) {
  #
  #						# get the corresponding GO description.
  #						my $final_go_desc = $GO_to_description->{$ele};
  #
  #					 # If the first element, include all this in the first line:
  #						if ( $ele_counter == 1 ) {
  #
  #							print REPORT join( "\t",
  #								$trinity_id,   $data_sample1,
  #								$data_sample2, $data_sample3,
  #								$data_sample4, $final_protein_id,
  #								$ele,          $final_go_desc,
  #								$protein_description ),
  #							  "\n";
  #
  #						}
  #
  #				   # Otherwise, indent, and print just the elements of the array
  #				   # and the protein descriptions:
  #						else {
  #
  #							print REPORT (
  #								"\t \t \t \t \t \t",
  #								$ele, "\t", $final_go_desc
  #							  ),
  #							  "\n";
  #						}
  #					}
  #				}
  #			}
  #		}
	}
	close DIFF_EXP;
	close REPORT;
}

# Get description of $protein_id from BLAST database.
sub get_protein_info_from_blast_DB {
	my ($protein_id) = @_;
	my $db = '/blastDB/swissprot';
	my $exec =
	    'blastdbcmd -db '
	  . $db
	  . ' -entry '
	  . $protein_id
	  . ' -outfmt "%t" -target_only | ';

	open( SYSCALL, $exec ) or die "Can't open the SYSCALL ", $!;

# Set default description as "NA". If protein is found in DB, overwrite description.
	my $protein_description = 'NA';
	while (<SYSCALL>) {
		chomp;
		if ( $_ =~ /RecName:\s+(.*)/i ) {
			$protein_description = $1;
		}
	}
	close SYSCALL;
	return $protein_description;
}
