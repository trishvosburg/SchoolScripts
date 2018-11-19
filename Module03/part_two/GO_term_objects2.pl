#!/usr/bin/perl
use warnings;
use strict;
use feature qw(say);
use GO;

# Get list of GO term objects and print in sorted order:
my $GO_terms = read_GO_desc();
foreach my $id ( sort keys $GO_terms ) {
	$GO_terms->{$id}->print_all();
}

# Returns hash of GO objects. Objects are created with data read in from GO file
sub read_GO_desc {
	my $GO_desc_file = '/scratch/go-basic.obo';
	open( GO_DESC, '<', $GO_desc_file ) or die $!;

	# Initialize $_ so that redefinition of $/ to regex will not cause warning:
	$_ = '';
	local $/ = /\[Term]|[Typedef]/;

	# Hash to store GO terms.
	my %GO_terms;

	while ( my $record = <GO_DESC> ) {
		chomp $record;

		# Instantiate new GO object with new() constructor:
		my $go = GO->new();

		# Invoke object's method, parse_GO_entry, to set attributes.
		$go->parse_GO_entry($record);

		# Object must have defined id attribute to be added to hash. This is
		# just done to make the program more robust:
		if ( defined $go->id() ) {
			$GO_terms{ $go->id() } = $go;
		}
	}
	close GO_DESC;
	return \%GO_terms;
}
