#!/usr/bin/perl
#simpledb.plx
use strict;
use warnings;
use POSIX;
use SDBM_File;

# Declare hash:
my %dbm;
# Specify filename to use:
my $db_file = "simpledb.dbm";

tie %dbm, 'SDBM_File', $db_file, O_CREAT|O_RDWR, 0644;

# Confirming success that the tie worked:
if (tied %dbm) {
	print "File $db_file now open.\n";
} else {
	die "Sorry, unable to open $db_file\n";
}

my %GO_ref;

$GO_ref{'term'} = 'GO1234';
$GO_ref{'desc'} = 'fake GO term';
$dbm{'GO1234'} = \%GO_ref;


foreach (sort keys(%dbm) ) {
	print "$_ => $dbm{$_}\n";
}