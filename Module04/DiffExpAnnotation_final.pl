#!/usr/bin/perl
use warnings;
use strict;
use feature 'say';
use Data::Dumper;
use List::Util 'uniq';
use BLAST;
use GO;
use DiffExp;
use Report;

print_report();

# Returns hash of BLAST objects
sub read_blast {

	my $blast_file = '/scratch/RNASeq/blastp.outfmt6';
	open( BLAST_FILE, '<', $blast_file ) or die $!;

	# Initialize $_:
	$_ = '';

	# Hash to store BLAST mappings.
	my %transcript_to_protein;

	# Read file and parse data of interest
	while ( my $record = <BLAST_FILE> ) {
		chomp $record;

		# Instantiate new BLAST object with new() constructor
		my $blast = BLAST->new( BLAST_transcript => $record );

  # Only add the first hit match with identity over 99%
  # Create hash with transcript attribute as the key and protein id as the value
		if ( $blast->get_pident() > 99
			&& not defined $transcript_to_protein{ $blast->get_transcript() } )
		{
			$transcript_to_protein{ $blast->get_transcript() } = $blast->get_sp;
		}
	}
	close BLAST_FILE;
	return \%transcript_to_protein;
}

# Returns a hash of GO objects
sub read_GO_desc {

	my $GO_desc_file = '/scratch/go-basic.obo';
	open( GO_DESC, '<', $GO_desc_file ) or die $!;

	# Hash to store gene-to-GO term descriptions mappings.
	my %GO_to_description;

	# Initialize $_ so that redefinition of $/ to regex will not cause warning:
	my $_ = '';
	local $/ = /\[Term]|[Typedef]/;

	# Read in the GO_desc file, chomp each line.
	while ( my $record = <GO_DESC> ) {
		chomp $record;

		# Instantiate new GO object with new() constructor:
		my $go = GO->new( GO_term => $record );

		# Object must have defined id attribute to be added to hash
		# Key is GO ID, value is $go object
		if ( defined $go->get_id() ) {
			$GO_to_description{ $go->get_id() } = $go;
		}

	}
	close GO_DESC;
	return \%GO_to_description;
}

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

# Creates DiffExp and Report objects
# Invokes Report's print_all() method to create the final summary file
sub print_report {

	# Call other subroutines:
	my $GO_to_description     = read_GO_desc();
	my $transcript_to_protein = read_blast();
	my $gene_to_GO            = read_gene_to_GO();

	# Create DiffExp object:
	my $diff_exp_file = '/scratch/RNASeq/diffExpr.P1e-3_C2.matrix';
	open( DIFF_EXP, '<', $diff_exp_file ) or die $!;

	while ( my $record = <DIFF_EXP> ) {
		chomp $record;

		# Instantiate new DiffExp object with new() constructor
		my $DiffExp =
		  DiffExp->new( transcript_ID => $record );

# Get the final protein ID by retrieving it from the transcript_to_protein hash:
		my $protein_id = $transcript_to_protein->{ $DiffExp->get_transcript() } // 'NA';
		
		# Create variable for the final GO terms array that contains the GO object:
		my @GO_terms;
		
		# Get the protein description by calling the appropriate subroutine:
		my $protein_desc = $protein_id ne 'NA' ?
			get_protein_info_from_blast_DB( $protein_id ) : 'NA';
			
		# Check if protein ID is found in gene_to_GO:
		if ( defined $gene_to_GO->{$protein_id} ) {
			
			# get corresponding GO terms in an array:
			my @GO_terms_array = uniq @{ $gene_to_GO->{$protein_id} };

			# For each element in GO terms array,
			foreach my $GO_id (sort @GO_terms_array ) {
				
				# If the $GO_id in the array is found in the description hash,
				if (defined $GO_to_description->{$GO_id}) {
					
					# Push the value of the hash onto the @GO_terms array
					push( @GO_terms, $GO_to_description->{$GO_id} );
				}
				
			}
		}

		# Invoke print_all:
		my $final_report = Report->new(
		diff_expressions => $DiffExp,
		protein_id       => $protein_id,
		GO_terms         => \@GO_terms,
		protein_desc     => $protein_desc
		);
					
		$final_report->print_all();	
	}
	close DIFF_EXP;
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
