#!/usr/bin/perl
use warnings;
use strict;
use feature qw(say);
use GO;
use Data::Dumper;

# Hash to store GO objects
my %GO_terms;

# Instantiate one GO object
my $go = GO->new( id => 'GO:0000001', name => 'mitochondrion inheritance');
 
# Add object to hash with its 'id' attribute as they key and the entire object as a value
$GO_terms{$go->id()} = $go;

### Just to show what the hash looks like:
say Dumper(%GO_terms);

