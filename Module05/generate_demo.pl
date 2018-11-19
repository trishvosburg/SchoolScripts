#!/usr/bin/perl
use warnings;
use strict;
use POSIX;
use SDBM_File; # Or GDBM_File / NDBM_File / AnyDBM_File
use feature 'say';

my %dbm;
my $db_file = "demo.dbm";

# O_CREAT is a flag that creates the database if it doesn't 
# already exist.

# O_RDWR is a symbol imported from POSIX module, which defines
# common labels for system value. In this case, we have
# specified the open read-write flag, telling perl we want
# to open the file for both reading and writing.

# 0644 specifies read and write access for us (6), but only
# read and write access for other groups and users (4)

tie %dbm, 'SDBM_File', $db_file, O_CREAT|O_RDWR, 0644;
$dbm{test_key} = 'test_value';
say $dbm{test_key};