package GO;
use Moose;

has 'id' => (
	is => 'rw',
	isa => 'Str'	
);

has 'name' => (
	is => 'rw',
	isa => 'Str'
);

has 'namespace' => (
	is => 'rw',
	isa => 'Str'
);

has 'def' => (
	is => 'rw',
	isa => 'Str'
);

has 'is_a' => (
	is => 'rw',
	isa => 'ArrayRef'
);

has 'alt_ids' => (
	is => 'rw',
	isa => 'ArrayRef'
);

1;