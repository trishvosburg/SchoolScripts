#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

my $gene_to_GO_file = '/scratch/gene_association_subset.txt';
my $blast_file      = '/scratch/RNASeq/blastp.outfmt6';
my $diff_exp_file   = '/scratch/RNASeq/diffExpr.P1e-3_C2.matrix';
my $GO_desc_file    = '/scratch/go-basic.obo';
my $report_file     = 'report.txt';

# Open a filehandle for the gene ID to GO term.
open( GENE_TO_GO, '<', $gene_to_GO_file ) or die $!;

# Open a filehandle for the BLAST output file.
open( BLAST, '<', $blast_file ) or die $!;

# Open a filehandle for the Trinity output file.
open( DIFF_EXP, '<', $diff_exp_file ) or die $!;

# Open a filehandle for the basic GO file.
open( GO_DESC, '<', $GO_desc_file ) or die $!;

# Open a filehandle to write the report.
open( REPORT, '>', $report_file ) or die $!;

# Hash to store gene-to-GO term mappings.
my %gene_to_GO;

# Hash to store gene-to-GO term descriptions mappings.
my %GO_to_description;

# Hash to store BLAST mappings.
my %transcript_to_protein;

# Subroutines.
read_GO_desc();
read_blast();
read_gene_to_GO();
print_report();

# Close files.
close GENE_TO_GO;
close BLAST;
close DIFF_EXP;
close GO_DESC;
close REPORT;

# Load transcript IDs of query sequence (qseqid) and SwissProt IDs of subject sequence
# (sseqid) without version number to hash for lookup.
sub read_blast {

	# Read in the BLAST file, chomp each line, and then split each line on tabs.
	# Trim the transcriptID so it doesn't include the version number.
	# Trim the protein ID column (2nd column) so it's only the protein ID.
	# Create a hash with transcriptID as the key and proteinID as the value.
	while ( my $line = <BLAST> ) {
		chomp $line;
		my @tab_split_blast = split( /\t/, $line );
		my $untrimmed_transcript_id = $tab_split_blast[0];		
		my $transcript_id;
		my $protein_id;
		if ( $untrimmed_transcript_id =~ m/^(c\d{1,4}_\w{1}\d{1}_\w{1}\d{1})/g ) {
			$transcript_id = $1;
		}
		my $untrimmed_protein_id = $tab_split_blast[1];
		if ( $untrimmed_protein_id =~ m/sp\|(\w+)\./g ) {
			$protein_id = $1;
		}
		$transcript_to_protein{$transcript_id} = $protein_id;
	}
}

# Print the hash to make sure it's correct:
# print Dumper(\%transcript_to_protein);

# Load protein IDs and corresponding GO terms to hash for lookup.
sub read_gene_to_GO {

	# Read in the GO annotation file, chomp each line, split each line on tabs.
	# Extract 2nd column which is the object ID.
	# Extract the 4th column which is the GO ID.
	# Create a hash with the object ID as the key and GO ID as the value.
	while ( my $line = <GENE_TO_GO> ) {
		chomp $line;
		my @tab_split_gene = split( /\t/, $line );
		my $object_id     = $tab_split_gene[1];
		my $go_id         = $tab_split_gene[4];

		# If the object ID already exists,
		if ( $gene_to_GO{$object_id} ) {

			# skip over it,
			next;

		} # otherwise, create it in the hash.
		else {
			$gene_to_GO{$object_id} = $go_id;
		}
	}
}

# Print the hash to make sure it's correct:
# print Dumper(\%gene_to_GO);

# Load GO terms and GO descriptions to hash for lookup.
sub read_GO_desc {

	# Change the EOL from "\n" to "[Term]" so that one entire GO term record will be read
	#	in for easier parsing.
	# Read in the GO_desc file, chomp each line.
	# Use regex to extract just the GO Terms from the "id:" field.
	# Use regex to extract just the GO Names from the "name:" field.
	# Create a hash with GO Term as the key and GO Name as the value.
	local $/ = '[Term]';
	while ( my $line = <GO_DESC> ) {
		my $go_id_2;
		my $go_name;
		chomp $line;
		if ( $line =~ m/id:\s(GO:[0-9]+)/g ) {
			$go_id_2 = $1;
		}
		if ( $line =~ m/name:\s(.*)/g ) {
			$go_name = $1;
		}
		$GO_to_description{$go_id_2} = $go_name if defined $go_id_2;
	}
}

# Print hash to make sure it's correct:
# print Dumper(\%GO_to_description);

# Loop through differential expression file; lookup the (SwissProt) protein ID + description
# and GO term + name; print results to REPORT output.
sub print_report {

	# Read in Differential expression file, chomp each line, split it on tabs.
	# Create trinityID and 4 data samples variables for easier parsing.
	# Default variables to NA. If information in question is found in the file,
	# overrwrite the NA (otherwise, the NA remains as a placeholder of sorts).
	while ( my $line = <DIFF_EXP> ) {
		chomp $line;
		my @tab_split_trinity = split( /\t/, $line );
		my $trinity_id       = $tab_split_trinity[0];
		my $data_sample1     = $tab_split_trinity[1];
		my $data_sample2     = $tab_split_trinity[2];
		my $data_sample3     = $tab_split_trinity[3];
		my $data_sample4     = $tab_split_trinity[4];
		my $final_protein_id  = 'NA';
		my $final_go_term = 'NA';
		my $final_go_desc = 'NA';
		my $protein_description = 'NA';
		
	   # Check if the trinityID is in the %transcript_to_protein hash; if it is:
		if ( defined $transcript_to_protein{$trinity_id} ) {

			# get corresponding protein ID.
			$final_protein_id = $transcript_to_protein{$trinity_id};

			# Check if protein ID is found in GENE_TO_GO hash, if it is:
			if ( defined $gene_to_GO{$final_protein_id} ) {

				# get corresponding GO term.
				$final_go_term = $gene_to_GO{$final_protein_id};
			
				# Check if GO term is found in GENE_DESC hash, if it is:
				if ( defined $GO_to_description{$final_go_term} ) {

					# get corresponding GO description.
					
					$final_go_desc = $GO_to_description{$final_go_term}; 
				
					# Call on get_protein_info_from_blast_DB subroutine to get protein description
					$protein_description = get_protein_info_from_blast_DB($final_protein_id);
	
				}
				#else { $finalGoDesc = 'NA'; }
			}
			#else { $finalGoTerm = 'NA'; }
		}
		#else { $protein_ID = 'NA'; }
		
		print REPORT join("\t",
			$trinity_id,   $final_protein_id,
			$final_go_term, $data_sample1,
			$data_sample2, $data_sample3,
			$data_sample4, $final_go_desc,
			$protein_description),
		  "\n";
	}
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
