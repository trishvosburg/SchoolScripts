#!/usr/bin/perl
use warnings;
use strict;
use feature qw(say);

# Introduce with $name
sub print_intro {
	my($name) = @_;
	say "My name is ", $name;
}

say "Hello World!";
print_intro("Trish");
print "Welcome to BINF6200";