#!/usr/bin/perl
use warnings;
use strict;
use GO;

# Based on predefined test data, will expect 14 successes.
use Test::More tests => 14;

# Initialize $_ so redefinition of $/ to regex will not cause warning;
$_ = '';
local $/ = /\[Term]|\[Typedef]/;

# Read in test data record-by-record:
while (<DATA>) {
	chomp;
	my $go = GO->new(GO_term => $_);
	
	# Check that all attributes defined:	
	is( $go->get_id(), 'GO:2001315', 'testing GO term ID' );
	is( $go->get_def(), 'The chemical reactions and pathways resulting in the formation of a UDP-4-deoxy-4-formamido-beta-L-arabinopyranose.', 'testing GO term definition' );
	is( $go->get_name(), 'UDP-4-deoxy-4-formamido-beta-L-arabinopyranose biosynthetic process', 
		'testing GO term name' );
	is( $go->get_namespace(), 'biological_process', 'testing GO term namespace');
	
	ok( defined $go->get_id() );
	ok( defined $go->get_def() );
	ok( defined $go->get_name() );
	ok( defined $go->get_namespace() );
	
	# Initialize is_a counter:
	my $isaCount = 0;
	
	# Loop through is_a array reference:
	foreach my $isaRef ( @{$go->get_is_as()} ) {
		ok( defined $isaRef );
		$isaCount++;
	}
	
	# Make sure that there is at least one is_a:
	ok ( $isaCount > 0 );
	
	# Initialize alt_id counter:
	my $altIdCount = 0;
	
	# Loop through alt_id array reference:
	foreach my $altIdRef ( @{$go->get_alt_ids()} ) {
		ok( defined $altIdRef );
		$altIdCount++;
	}
	
	# Make sure there is at least one alt_id:
	ok( $altIdCount > 0 );
}

# Indicates that tests are done:
done_testing();

# Everything below __END__ is treated as input for DATA filehandle
__END__
[Term]
id: GO:2001315
name: UDP-4-deoxy-4-formamido-beta-L-arabinopyranose biosynthetic process
namespace: biological_process
alt_id: GO:0019901
def: "The chemical reactions and pathways resulting in the formation of a UDP-4-deoxy-4-formamido-beta-L-arabinopyranose." [CHEBI:47027, GOC:yaf, UniPathway:UPA00032]
synonym: "UDP-4-deoxy-4-formamido-beta-L-arabinopyranose anabolism" EXACT [GOC:obol]
synonym: "UDP-4-deoxy-4-formamido-beta-L-arabinopyranose biosynthesis" EXACT [GOC:obol]
synonym: "UDP-4-deoxy-4-formamido-beta-L-arabinopyranose formation" EXACT [GOC:obol]
synonym: "UDP-4-deoxy-4-formamido-beta-L-arabinopyranose synthesis" EXACT [GOC:obol]
is_a: GO:0009226 ! nucleotide-sugar biosynthetic process
is_a: GO:0046349 ! amino sugar biosynthetic process
is_a: GO:2001313 ! UDP-4-deoxy-4-formamido-beta-L-arabinopyranose metabolic process
