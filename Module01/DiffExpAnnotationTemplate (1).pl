#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

my $gene_to_GO_file = '/scratch/gene_association_subset.txt';
my $blast_file      = '/scratch/RNASeq/blastp.outfmt6';
my $diff_exp_file   = '/scratch/RNASeq/diffExpr.P1e-3_C2.matrix';
my $GO_desc_file    = '/scratch/go-basic.obo';
my $report_file     = 'sample_report.txt';

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

# Hash to store GO term-to-GO description mappings.
my %GO_to_description;

# Hash to store BLAST mappings.
my %transcript_to_protein;

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

    # FILL IN YOUR CODE HERE. THIS SUBROUTINE SHOULD:
	#	Read in the BLAST file, and store the transcript ID and SwissProt ID (do not
	#	include the version number) of each line into the appropriate hash. Think about
	#	which ID should act as the key and which should act as the value; it may help
	#	to read the rest of the program's tasks to figure out how each file can be mapped
	#	to one another.
	
#	while ( ... ) {
#		...
#	}
#}

# Load protein IDs and corresponding GO terms to hash for lookup.
#sub read_gene_to_GO {
#
#    # FILL IN YOUR CODE HERE. THIS SUBROUTINE SHOULD:
#	#	Read in the GO annotation file, and store the object ID (2nd column) and GO ID
#	#	(5th column) into the appropriate hash. Think about which should be the key and 
#	#	which should be the value.
#
#	while ( ... ) {
#		...
#		
#		# Some object IDs show up more than once in the file. For now, only add to the
#		# hash if an object ID is not already in it.
#		...
#	}
#}

# Load GO terms and GO descriptions to hash for lookup.
sub read_GO_desc {

    # FILL IN YOUR CODE HERE. THIS SUBROUTINE SHOULD:
	#   Read in the filtered GO terms and annotations file, and store the GO ID and GO name
	#	into the appropriate hash. Again, which information makes more sense to act as the 
	#	key: GO ID or GO name?
	

	# Change the EOL from "\n" to "[Term]" so that one entire GO term record will be read 
	# in for easier parsing.
	local $/ = '[Term]';
	while ( ... ) {
		...
		
		# Some GO term entries have missing IDs or names. To avoid getting an uninitialized
		# warning, only add to the hash if both an ID and name can be found.
		...
	}
}

# Loop through differential expression file; lookup the (SwissProt) protein ID + description
# and GO term + name; print results to REPORT output.
sub print_report {

    # FILL IN YOUR CODE HERE. THIS SUBROUTINE SHOULD:
	#   Print to the output file where each line from the Trinity BLAST output is mapped 
	#	to its corresponding protein ID + description and GO term + name. Use "NA" as the 
	#	default values for protein ID + description and GO term + name. To get the protein
	#	description, call on the get_protein_info_from_blast_DB subroutine.
	
	while ( ... ) {
		...
	}
}

# Get description of $protein_id from BLAST database. 
# **This subroutine does not require any modifications**
sub get_protein_info_from_blast_DB {
	my ( $protein_id ) = @_;
	my $db = '/blastDB/swissprot';
	my $exec = 'blastdbcmd -db '
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
