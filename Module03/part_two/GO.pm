package GO;
use Moose;
use feature qw(say);

# Method to print fields from GO term
sub print_all {
	my ($self) = @_;

	# Check if object has defined ID value first
	if ( $self->id() ) {
		say join( "\t",
			$self->id(), $self->name(), $self->namespace(), $self->def() );

		# Not all GO terms have is_a/alt_id fields, so must check if attributes
		# defined first
		if ( defined $self->is_as() ) {
			foreach my $is_a ( @{ $self->is_as() } ) {
				say "is_a:\t", $is_a;

			}
		}
		if ( defined $self->alt_ids() ) {
			foreach my $alt_id ( @{ $self->alt_ids() } ) {
				say "alt_id:\t", $alt_id;
			}
		}
	}

	# Otherwise, print helpful message:
	else {
		say "This GO term cannot be printed.";
	}
}

# Method that accepts one GO term record and parses it to set attribute values of object:
sub parse_GO_entry {
	my ( $self, $record ) = @_;

	# Regex to get id, name, namespace, and def via named captures:
	my $parsing_regex = qr/
		^id:\s+(?<id>.*?)\s+
		^name:\s+(?<name>.*?)\s+
		^namespace:\s+(?<namespace>.*?)\s+.*
		^def:\s+\"(?<def>.*?)\"\s+\[
		/msx;

	# Regex to capture all is_as via named captures:
	my $findIsa = qr/
		^is_a:\s+(?<is_a>.*?)\s+!
	/msx;

	# Regex to capture all alt_id's via named capture.
	my $findAltId = qr/
		^alt_id:\s+(?<alt_id>.*?)\s+
	/msx;

	# If record can be parsed, set attributes. Otherwise, do nothing:
	if ( $record =~ /$parsing_regex/ ) {
		$self->id( $+{id} );
		$self->name( $+{name} );
		$self->namespace( $+{namespace} );
		$self->def( $+{def} );

		# Push each is_a found into @is_as:
		my @is_as = ();
		while ( $record =~ /$findIsa/g ) {
			push( @is_as, $+{is_a} );
		}

		# Push each alt_id found into @alt_ids:
		my @alt_ids = ();
		while ( $record =~ /$findAltId/g ) {
			push( @alt_ids, $+{alt_id} );
		}
		$self->alt_ids( \@alt_ids );
	}
}
has 'id' => (
	is  => 'rw',
	isa => 'Str'
);

has 'name' => (
	is  => 'rw',
	isa => 'Str'
);

has 'namespace' => (
	is  => 'rw',
	isa => 'Str'
);

has 'def' => (
	is  => 'rw',
	isa => 'Str'
);
has 'is_as' => (
	is  => 'rw',
	isa => 'ArrayRef[Str]'
);
has 'alt_ids' => (
	is  => 'rw',
	isa => 'ArrayRef[Str]'
);

1;
