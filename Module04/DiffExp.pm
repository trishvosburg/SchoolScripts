package DiffExp;
use Moose;
use MooseX::FollowPBP;
use feature 'say';

# Accepts one transcript and sets attributes from parsed values:
sub BUILD{
	my ( $self, $args ) = @_;
	my $record = $args->{transcript_ID};
	
	# Split on tabs:
	my @tabSplitRecord = split (/\t/, $record);
	
	# Set attributes:
	$self->{transcript} = $tabSplitRecord[0];
	$self->{sp_ds} = $tabSplitRecord[1];
	$self->{sp_hs} = $tabSplitRecord[2];
	$self->{sp_log} = $tabSplitRecord[3];
	$self->{sp_plat} = $tabSplitRecord[4];
	
}

has 'transcript' => (
	is => 'ro',
	isa => 'Str',
	clearer => 'clear_transcript',
	predicate => 'has_transcript'
);

has 'sp_ds' => (
	is => 'ro',
	isa => 'Num',
	clearer => 'clear_sp_ds',
	predicate => 'has_sp_ds'
);

has 'sp_hs' => (
	is => 'ro',
	isa => 'Num',
	clearer => 'clear_sp_hs',
	predicate => 'has_sp_hs'
);

has 'sp_log' => (
	is => 'ro',
	isa => 'Num',
	clearer => 'clear_sp_log',
	predicate => 'has_sp_log'
);

has 'sp_plat' => (
	is => 'ro',
	isa => 'Num',
	clearer => 'clear_sp_plat',
	predicate => 'has_sp_plat'
);

1;