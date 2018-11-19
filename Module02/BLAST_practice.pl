#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use Data::Dumper;

#my $blast_file      = '/scratch/RNASeq/blastp.outfmt6';
my $blast_file = '/Users/trish/workspace/BINF6200/Module01/blastp.outfmt6';


# Open a filehandle for the BLAST output file.
open( BLAST, '<', $blast_file ) or die $!;

# Hash to store BLAST mappings.
my %transcript_to_protein;

# Subroutines

read_blast();

close BLAST;

sub read_blast {

	# Read in the BLAST file, chomp each line, and then split each line on tabs
	# Trim the transcriptID so it doesn't include the version number
	# Trim the protein ID column (2nd column) so it's only the protein ID
	# Create a hash with transcriptID as the key and proteinID as the value
	while ( my $line = <BLAST> ) {
		chomp $line;
		my @tabSplitBLAST = split( /\t/, $line );
		my $limit = 99;
		my $blast_percent = $tabSplitBLAST[2];
		my $transcriptID;
		my $proteinID;
		my $untrimmedTranscriptID = $tabSplitBLAST[0];
		if ( $untrimmedTranscriptID =~ m/^(c\d{1,4}_\w{1}\d{1}_\w{1}\d{1})/g ) {
			$transcriptID = $1;
		}
		my $untrimmedProteinID = $tabSplitBLAST[1];
		if ( $untrimmedProteinID =~ m/sp\|(\w+)\./g ) {
			$proteinID = $1;
		}
		# If there is more than one transcriptID, then take the FIRST output with value higher than 99
		if ( ($transcript_to_protein{$transcriptID}) && ($blast_percent > $limit))  {
			# add it to the hash?
			$transcript_to_protein{$transcriptID} = $proteinID;
		}
	}
}

# Print the hash to make sure it's correct:
print Dumper(\%transcript_to_protein);