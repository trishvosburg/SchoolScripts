#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

# Objective: parses the BLAST file completely with a regular expression, printing a tabular output to a file named parsed_blast.txt. The fields we want are:

# transcript (c1000_g1_i1 in sample line below)
# isoform (m.799)
# gi (48474761)
# sp (O94288.1)
# prot (NOC3_SCHPO)
# pident (100.00)
# length (747)
# mismatch (0)
# gapopen (2)

# Example line:
# c1000_g1_i1|m.799 gi|48474761|sp|O94288.1|NOC3_SCHPO 100.00 747 0 2 5 751 1 740.0 1506

#For any non-parsed lines, output them to not_parsed_blast.txt.

read_blast();

sub read_blast {
	# Variables for files:
	my $blast_file = '/scratch/RNASeq/blastp.outfmt6';

	# Open filehandle for blast file:
	open( BLAST, '<', $blast_file ) or die $!;

	# Initialize $_
	$_ = '';

	# Read file and parse data of interest.
	while ( my $long_blast = <BLAST> ) {
		chomp $long_blast;

		# Regex to find
		my $parsing_regex = qr/
			^(?<transcript>c\d{1,4}_\w{1}\d{1}_\w{1}\d{1})\|
			(?<isoform>m[.][0-9]+?)\s+
			gi\|(?<gi>[0-9]+?)\|
			sp\|(?<sp>.*[.]\d{1}?)\|
			(?<prot>.*_.*?)\s+
			(?<pident>[0-9]+[.]\d{2})\s+
			(?<length>[0-9]+?)\s+
			(?<mismatch>[0-9]+?)\s+
			(?<gapopen>[0-9]+?)
			/msx;

		if ( $long_blast =~ /$parsing_regex/ ) {
			say join( "\n",
				$+{transcript}, $+{isoform},  $+{gi},
				$+{sp},         $+{prot},     $+{pident},
				$+{length},     $+{mismatch}, $+{gapopen} );
		}
		else {
			say STDERR $long_blast;
		}

	}
}
