#!/usr/bin/perl
#simpledb.plx
use strict;
use warnings;
use POSIX;
use SDBM_File;

# Following program is a simple DBM database manipulator, which we can 
# use to store on disk whatever information we like, in form of 
# key-value pairs:

# Declare hash:
my %dbm;
# Specify filename to use:
my $db_file = "simpledb.dbm";

# Use the above values to tie together the hash and the file
tie %dbm, 'SDBM_File', $db_file, O_CREAT|O_RDWR, 0644;

# Confirming success that the tie worked:
if (tied %dbm) {
	print "File $db_file now open.\n";
} else {
	die "Sorry, unable to open $db_file\n";
}

$_ = ""; 		# Make sure $_ is defined

# Prompts user for STDIN and calls appropriate subroutines:
# Loop continues until $_ can be matched to the regex /^q/i
# Basically until the user enters q or Quit
until (/^q/i) {
	print "what would you like to do? ('o' for options): ";
	chomp ($_ = <STDIN>);
	if ($_ eq "o") { dboptions() }
	elsif ($_ eq "r") { readdb() }
	elsif ($_ eq "l") { listdb() }
	elsif ($_ eq "w") { writedb() }
	elsif ($_ eq "d") { deletedb() }
	elsif ($_ eq "x") { cleardb() }
	else { print "Sorry, not a recognized option.\n"; }
}

# Untie from hash:
untie %dbm;

#*** Option Subs ***#

# Displays list of options
sub dboptions {
	print<<EOF;
		Options available:
		o - view options
		r - read entry
		l - list all entries
		w - write entry
		d - delete entry
		x - delete all entries
EOF
}

# Lets user specify name of hash key and displays corresponding value
# (unless key doesn't exist)
sub readdb {
	my $keyname = getkey();
	if (exists $dbm{"$keyname"}) {
		print "Element, '$keyname' has value $dbm{$keyname}";
	} else {
		print "Sorry, this element does not exist.\n";
	}
}

# Lists all key-value pairs in database
sub listdb {
	foreach (sort keys(%dbm) ) {
		print "$_ => $dbm{$_}\n";
	}
}

# Lets user specify both key and a value, and as long as the key hasn't
# already been used, uses this pair to define a new entry in database
sub writedb {
	my $keyname = getkey();
	my $keyval = getval();
	
	if (exists $dbm{$keyname} ) {
		print "Sorry, this element already exists.\n";
	} else {
		$dbm{$keyname} = $keyval;
	}
}

# Lets user specify a key, and following a warning, deletes corresponding entry
sub deletedb {
	my $keyname = getkey();
	if (exists $dbm{$keyname} ) {
		print "This will delete the entry $keyname.\n";
		delete $dbm{$keyname} if besure();
	}
}

# Lets user wipe whole database clean
sub cleardb {
	print "This will delete the entire contents of the current database.\n";
	undef %dbm if besure();
}

#*** Input Subs ***#

# Prompts user for an input, which is chomped and returned to calling code
sub getkey {
	print "Enter key name of element: ";
	chomp ($_ = <STDIN>);
	$_;
}

# Prompts user for an input, which is chomped and returned to calling code
sub getval {
	print "Enter value of element: ";
	chomp ($_ = <STDIN>);
	$_;
}

# Adds warnings to potentially dangerous operations
# Prompts user for input, but then return TRUE if and only if that input matches
# /^y/i, that is, y or yes, etc.
sub besure {
	print "Are you sure you want to do this?";
	$_ = <STDIN>;
	/^y/i;
}