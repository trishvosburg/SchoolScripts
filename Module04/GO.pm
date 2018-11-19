package GO;
use Moose;
use MooseX::FollowPBP;
use feature qw(say);

# Method to print fields from GO term
sub print_all {
	my ($self) = @_;

	# Check if object has defined ID value first
	if ( $self->get_id() ) {
		say join( "\t",
			$self->get_id(), $self->get_name(), $self->get_namespace(), $self->get_def() );

		# Not all GO terms have is_a/alt_id fields, so must check if attributes
		# defined first
		if ( defined $self->get_is_as() ) {
			foreach my $is_a ( @{ $self->get_is_as() } ) {
				say "is_a:\t", $is_a;

			}
		}
		if ( defined $self->get_alt_ids() ) {
			foreach my $alt_id ( @{ $self->get_alt_ids() } ) {
				say "alt_id:\t", $alt_id;
			}
		}
	}

	# Otherwise, print helpful message:
	else {
		say "This GO term cannot be printed.";
	}
}

# Accepts one GO term record and sets attributes from parsed values:
sub BUILD {
	my ( $self, $args ) = @_;
	my $record = $args->{GO_term};
	
	# Parsing:
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
		$self->{id} = $+{id};
		$self->{name} =  $+{name};
		$self->{namespace} = $+{namespace};
		$self->{def} =  $+{def};
		
		# Push each is_a found into @is_as:
		my @is_as = ();
		while ( $record =~ /$findIsa/g ) {
			push( @is_as, $+{is_a} );
		}
		
		$self->{is_as} = \@is_as;
		
		# Push each alt_id found into @alt_ids:
		my @alt_ids = ();
		while ( $record =~ /$findAltId/g ) {
			push( @alt_ids, $+{alt_id} );
		}
		$self->{alt_ids}= \@alt_ids;
	}
	
}

has 'id' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_id',
	predicate => 'has_id'
);

has 'name' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_name',
	predicate => 'has_name'
);

has 'namespace' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_namespace',
	predicate => 'has_namespace'
);

has 'def' => (
	is  => 'ro',
	isa => 'Str',
	clearer => 'clear_def',
	predicate => 'has_def'
);
has 'is_as' => (
	is  => 'ro',
	isa => 'ArrayRef[Str]',
	clearer => 'clear_is_as',
	predicate => 'has_is_as'
);
has 'alt_ids' => (
	is  => 'ro',
	isa => 'ArrayRef[Str]',
	clearer => 'clear_alt_ids',
	predicate => 'has_alt_ids'
);

1;
