#!/usr/bin/perl
use warnings;
use strict;
use DiffExp;

# Based on test data, will expect n successes:
use Test::More tests => 10;

# Initialize $_:
$_ = '';

# Reads in test data record-by-record:
while ( <DATA> ) {
	chomp;
	my $DiffExp = DiffExp->new(transcript_ID => $_);
	
	# Ensures all attributes are defined:
	is( $DiffExp->get_transcript(), 'c231_g1_i2', 'testing transcript ID');
	is( $DiffExp->get_sp_ds(), '0.00', 'testing_sp_ds' );
	is( $DiffExp->get_sp_hs(), '34.96', 'testing sp_hs');
	is( $DiffExp->get_sp_log(), '0.00', 'testing sp_log');
	is( $DiffExp->get_sp_plat(), '3.75', 'testing sp_plat');
	
	ok( $DiffExp->get_transcript() );
	ok( $DiffExp->get_sp_ds() );
	ok( $DiffExp->get_sp_hs() );
	ok( $DiffExp->get_sp_log() );
	ok( $DiffExp->get_sp_plat() );
}
done_testing();

__END__
c231_g1_i2	0.00	34.96	0.00	3.75