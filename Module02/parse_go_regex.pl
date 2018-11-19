#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

read_GO_desc();

sub read_GO_desc {
	my $GO_desc_file = '/scratch/go-basic.obo';
	open( GO_DESC, '<', $GO_desc_file ) or die $!;

	# Initialize $_ so redefinition of $/ to regex will not cause warning.
	$_ = '';
	local $/ = /\[Term]|\[Typedef]/;

	# Read file and parse for data of interest.
	while ( my $long_GO_desc = <GO_DESC> ) {
		chomp $long_GO_desc;

		my $parsing_regex = qr/        
			 ^id:\s+(?<id>GO:[0-9]+)\s+
			 ^name:\s+(?<name>.*?)\s+ 
			 ^namespace:\s+(?<namespace>.*?)\s+
			 ^def:\s+"(?<def>.*)"\s+     
			/msx;

		# Regex to get all is_a Go Terms
		my $findIsa = qr/
			^is_a:\s+(?<isa>.*?)\s+!
		/msx;

		# Regex to get all alt_id Go Terms
		my $findAltId = qr/
			^alt_id:\s+(?<alt_id>.*?)\s+
		/msx;

		if ( $long_GO_desc =~ /$parsing_regex/ ) {
			say join( "\n", $+{id}, $+{name}, $+{namespace}, $+{def} );

			say "alt_ids:";
			my @alt_ids = ();
			while ( $long_GO_desc =~ /$findAltId/g ) {
				push( @alt_ids, $+{alt_id} );
			}

# Not all records contain alt IDs, so check first before printing.
			if (@alt_ids) {
				say join( ",", @alt_ids );
			}

			say "isa:";
			my @isas = ();
			while ( $long_GO_desc =~ /$findIsa/g ) {
				push( @isas, $+{isa} );
			}
			say join( ",", @isas ), "\n";
		}
		else {
			say STDERR $long_GO_desc;
		}
	}
}
