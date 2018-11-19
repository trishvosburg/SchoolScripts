package BLAST;
use Moose;
use feature qw(say);

#######
# 9 attributes declared (try to give each attribute a type as specific as possible, e.g. don't use "Any"):
# transcript (c1000_g1_i1 in sample line below)
# isoform (m.799)
# gi (48474761)
# sp (O94288.1)
# prot (NOC3_SCHPO)
# pident (100.00)
# length (747)
# mismatch (0)
# gapopen (2)

# Example line:
# c1000_g1_i1|m.799 gi|48474761|sp|O94288.1|NOC3_SCHPO 100.00 747 0 2 5 751 1 740.0 1506
#######

# Prints all the object's attributes in a tab-separated format, followed by a newline at the end:
sub print_all {

	# Invokes accessor method on itself, the object
	# Accessor method is invoked on object name
	my ($self) = @_;

	# Check if object has defined transcript value first
	if ( $self->transcript() ) {
		say join( "\t",
			$self->transcript(), $self->isoform(),  $self->gi(),
			$self->sp(),         $self->prot(),     $self->pident(),
			$self->len(),        $self->mismatch(), $self->gapopen() ),
		  "\n";
	}

	# If not, print message:
	else {
		say "This transcript cannot be printed.";
	}
}

# Accepts a single line of BLAST input, parses it, and sets the attributes of the object:
# First parameter is $self and is automatically passed as first parameter to any object method.
# Second parameter is $record and it is explicitly passed by parse_blast.pl
# Parses $record with regex and sets values to object's attributes.
sub parse_blast_hit {
	my ( $self, $record ) = @_;

	# Regex to get all nine attributes via named captures:
	my $parsing_regex = qr/
			^(?<transcript>c\d{1,4}_\w{1}\d{1}_\w{1}\d{1})\|
			(?<isoform>m[.][0-9]+?)\s+
			gi\|(?<gi>[0-9]+?)\|
			sp\|(?<sp>.*[.]\d{1}?)\|
			(?<prot>.*_.*?)\s+
			(?<pident>[0-9]+[.]\d{2})\s+
			(?<len>[0-9]+?)\s+
			(?<mismatch>[0-9]+?)\s+
			(?<gapopen>[0-9]+?)
			/msx;

	# If record can be parsed, set attributes. Otherwise, do nothing.
	if ( $record =~ /$parsing_regex/ ) {
		$self->transcript( $+{transcript} );
		$self->isoform( $+{isoform} );
		$self->gi( $+{gi} );
		$self->sp( $+{sp} );
		$self->prot( $+{prot} );
		$self->pident( $+{pident} );
		$self->len( $+{len} );
		$self->mismatch( $+{mismatch} );
		$self->gapopen( $+{gapopen} );

	}
}

# Declare attributes:
has 'transcript' => (
	is  => 'rw',
	isa => 'Str'
);

has 'isoform' => (
	is  => 'rw',
	isa => 'Str'
);

has 'gi' => (
	is  => 'rw',
	isa => 'Int'
);

has 'sp' => (
	is  => 'rw',
	isa => 'Str'
);

has 'prot' => (
	is  => 'rw',
	isa => 'Str'
);

has 'pident' => (
	is  => 'rw',
	isa => 'Num'
);

has 'len' => (
	is  => 'rw',
	isa => 'Num'
);

has 'mismatch' => (
	is  => 'rw',
	isa => 'Num'
);

has 'gapopen' => (
	is  => 'rw',
	isa => 'Num'
);

1;
