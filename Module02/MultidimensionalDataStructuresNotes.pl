#usr/bin/perl
use warnings;
use strict;
use feature qw(say);
use Data::Dumper;

# Three approaches to creating an array of array references:

## One: declare references explicitly

my @student1 = (56, 60, 55); 
my @student2 = (45, 70, 54);
my @student3 = (70, 67, 70);

# Create explicit array references.
my $student1_ref = \@student1;
my $student2_ref = \@student2;
my $student3_ref = \@student3;

# Create multidimensional array (MDA) and dump to check:
my @AoA1 = ($student1_ref, $student2_ref, $student3_ref);
#print Dumper(@AoA1);

## Two: skip reference names

my @student1_ex2 = (56, 60, 55); 
my @student2_ex2 = (45, 70, 54);
my @student3_ex2 = (70, 67, 70);

# Create MDA and dump to check:
my @AoA2 = (\@student1_ex2, \@student2_ex2, \@student3_ex2);
#print Dumper(@AoA2);

## Three: create anonymous arrays
my @AoA3 = (
	[ 56, 60, 55 ],
	[ 45, 70, 54 ],
	[ 70, 67, 70 ],
);
#print Dumper(@AoA3);

# To print a value from a MDA, use same syntax as when dereferencing an array reference, with an extra layer:
#print $AoA3[1]->[0]; # or:
#print $AoA3[1][0];
#print ${$AoA3[1]}[0];

# To print all values of an array in a MDA:
#foreach my $score ( @{$AoA3[0]} ) {
#	print $score, " ";
#}

## Another way: multidimensional hash (MDH) --> hash of arrays (HoA) where keys will be some arbitrary scalar 
# data and values will be array references:
my %HoA = (
	'student1' => [ 56, 60, 55 ],
	'student2' => [ 45, 70, 54 ],
	'student3' => [ 70, 67, 70 ],
);
#print Dumper(%HoA);

# Notice how the key-value pairs are not dumped in student order, unlike when we dumped the values from a MDA. 
# Recall that arrays are ordered lists that are indexed by numbers, whereas hashes are sparsely indexed by strings 
# -- this means index "c" can exist without index "a" or "b", unlike in arrays where index 3 cannot exist without index 1 and 2.

# To print a value from a MDH, use the arrow-notation since that's the easiest syntax to remember. 
#print $HoA{student2}->[0]; #or 
#print $HoA{student2}[0]; 

## Hash of hashes:
my %HoH = (
	'Chuck' => {
		'Mod1' => 50,
		'Mod2' => 45,
		'Mod3' => 35,
		'Mod4' => 50,
		'Mod5' => 40,
	},
	'Verena' => {
		'Mod1' => 49,
		'Mod2' => 50,
		'Mod3' => 38,
		'Mod4' => 32,
		'Mod5' => 48,
	},
);
#print "Dumper:\n";
#print Dumper(%HoH);

foreach my $name (sort keys %HoH) {
	my $mod_counter = 0;
	
	foreach my $module (sort keys $HoH{$name}) {
		$mod_counter++;
		
		if ($mod_counter == 1) {
			print $name;
		} else {
			print " ";
		}
		print "\t", $module, "\t", $HoH{$name}{$module}, "\n";
		
	}
}
