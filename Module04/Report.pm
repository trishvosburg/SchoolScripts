package Report;
use Moose;
use MooseX::FollowPBP;
use feature qw(say);
use DiffExp;
use GO;

# Open report filehandle
open( REPORT, '>', 'final_report.txt' ) or die $!;

sub BUILD {

	# Pass in variables from DiffExpAnnotation_final:
	my ( $self, $args ) = @_;

	# Set attributes:
	$self->{diff_expressions} = $args->{diff_expressions};
	$self->{protein_id}       = $args->{protein_id};
	$self->{GO_terms}         = $args->{GO_terms};
	$self->{protein_desc}     = $args->{protein_desc};
}

# Print the report
sub print_all {
	my ($self) = @_;

	# Declare element counter
	my $ele_counter = 0;

	# Declare baseline
	my $base_line = '';

	# For each GO id in the array of GO terms,
	foreach my $GO_id ( sort @{ $self->get_GO_terms() } ) {

		# Increase the element counter
		$ele_counter++;

		# If the element counter is 1, print everything out
		if ( $ele_counter == 1 ) {
			$base_line = join(
				"\t", $self->get_diff_expressions()->get_transcript(),
				$self->get_diff_expressions()->get_sp_ds(),
				$self->get_diff_expressions()->get_sp_hs(),
				$self->get_diff_expressions()->get_sp_log(),
				$self->get_diff_expressions()->get_sp_plat(),
				$self->get_protein_id(),
				$GO_id->get_id(),
				$GO_id->get_name(),
				$self->get_protein_desc()
			);
		}

		# Otherwise, just print the indented information
		else {
			$base_line =
			    "\t \t \t \t \t \t" . $GO_id->get_id() . "\t" . $GO_id->get_name();
		}
		say REPORT $base_line;
	}
}

# Include all methods and attributes required for this class
has 'diff_expressions' => (
	is        => 'ro',
	isa       => 'DiffExp',
	clearer   => 'clear_diff_expressions',
	predicate => 'has_diff_expressions'
);

has 'protein_id' => (
	is        => 'ro',
	isa       => 'Str',
	clearer   => 'clear_protein_id',
	predicate => 'has_protein_id'
);

has 'protein_desc' => (
	is        => 'ro',
	isa       => 'Str',
	clearer   => 'clear_protein_desc',
	predicate => 'has_protein_desc'
);

has 'GO_terms' => (
	is        => 'ro',
	isa       => 'ArrayRef[GO]',
	clearer   => 'clear_GO_terms',
	predicate => 'has_GO_terms'
);

1;
