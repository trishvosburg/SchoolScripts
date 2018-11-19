#!/usr/bin/perl
use strict;
use warnings;

# Load CGI
use CGI;

# Create new CGI instance:
my $query = new CGI;

# Get name parameter from $query
my $name = $query->param('Name');

# Print $query header
print $query->header();

# print Hello World
print "Hello World!";