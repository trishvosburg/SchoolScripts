#!/usr/bin/perl
use warnings;
use strict;
use feature qw(say);
use GO;

# Class name (invocant, GO), followed by arrow operator, and then new() constructor.
# Within new() are the attribute names as the keys and attribute values as the values.
# The names must exactly match what is within the GO module, case-sensitivity and all.
# Object instance is assigned to variable $go.
#my $go = GO->new( id => 'GO:0000001', name => 'mitochondrion inheritance');

my $go = GO->new(
	id        => 'GO:0000002',
	name      => 'mitochondrial genome maintenance',
	namespace => 'biological_process',
	def =>
'def: "The maintenance of the structure and integrity of the mitochondrial genome; includes replication and segregation of the mitochondrial chromosome." [GOC:ai, GOC:vw]',
	is_a => 'GO:0007005 ! mitochondrion organization'
);

# Object name (invocant, id and name), arrow operator, and accesor method ().
#say $go->id(), "\t", $go->name();
say $go->id(), "\t", $go->name(), "\t", $go->namespace(), "\t", $go->def(),
  "\t", $go->is_a();
