#!/usr/bin/perl
use BLAST;
use warnings;
use strict;


# Include as many BLAST hits as you want as your testing data

# Based on predefined test data, will expect 900 successes (9 attributes, 100 rows)
use Test::More tests => 18;

# Initialize $_:
$_ = '';

# Reads in test data record-by-record. DATA is a special filehandle for testing.
# Reads everything below --END-- as input "file" which allows test script to be
# created with its own built-in test data.
while ( <DATA> ) {
	chomp;
	my $blast = BLAST->new( BLAST_transcript => $_ );
	
	# Ensures all attributes are defined:
	like ($blast->get_transcript(), '/c\d{1,4}_\w{1}\d{1}_\w{1}\d{1}/');
	like ($blast->get_isoform(), '/[0-9]+?/');
	like ($blast->get_gi(), '/[0-9]+?/');
	like ($blast->get_sp(), '/.*/');
	like ($blast->get_prot(), '/.*_.*?/');
	like ($blast->get_pident(), '/[0-9]+[.]\d{2}/');
	like ($blast->get_len(), '/[0-9]+?/');
	like (defined $blast->get_mismatch(), '/[0-9]+?/');
	like (defined $blast->get_gapopen(), '/[0-9]+?/');
	
	
	ok( $blast->get_transcript() );
	ok( $blast->get_isoform() );
	ok( $blast->get_gi() );
	ok( $blast->get_sp() );
	ok( $blast->get_prot() );
	ok( $blast->get_pident() );
	ok( $blast->get_len() );
	ok( defined $blast->get_mismatch() );
	ok( defined $blast->get_gapopen() );
	
}
done_testing();

__END__
c880_g1_i1|m.697	gi|74698439|sp|Q9UT73.1|YIPH_SCHPO	100.00	133	0	0	1	133	8	140	7e-90	  278