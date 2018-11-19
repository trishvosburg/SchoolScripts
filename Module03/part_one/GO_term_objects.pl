#!/usr/bin/perl
use warnings;
use strict;
use feature qw(say);
use Data::Dumper;
use GO;

####### Example from lecture slides:
# Hash to store GO objects
#my %GO_terms;

# Instantiate one GO object
#my $go = GO->new( id => 'GO:0000001', name => 'mitochondrion inheritance');
 
# Add object to hash with its 'id' attribute as they key and the entire object as a value
#$GO_terms{$go->id()} = $go;

### Just to show what the hash looks like:
#say Dumper(%GO_terms);
#######

read_GO_desc();

sub read_GO_desc {
	my $GO_desc_file = '/scratch/go-basic.obo';
	open( GO_DESC, '<', $GO_desc_file ) or die $!;
	
	# Hash to store GO objects
	my %GO_terms;
	
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
			 ^def:\s+"(?<def>.*?)"\s+    
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

			my @alt_ids = ();
			while ( $long_GO_desc =~ /$findAltId/g ) {
				push( @alt_ids, $+{alt_id} );
			}

			my @isas = ();
			while ( $long_GO_desc =~ /$findIsa/g ) {
				push( @isas, $+{isa} );
			}
			
			# Instantiate GO object
			my $go = GO->new( id => $+{id}, name => $+{name}, namespace => $+{namespace}, def => $+{def}, is_a => \@isas, alt_ids => \@alt_ids);
			
			# Add object to hash with its 'id' attribute as they key and the entire object as a value
			$GO_terms{$go->id()} = $go;
			
			#
		}
		else {
			say STDERR $long_GO_desc;
		}
	}
	close GO_DESC;
	say Dumper(%GO_terms);
}

