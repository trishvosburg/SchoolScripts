#!/usr/bin/perl
use warnings;
use strict;
use feature qw(say);
use BLAST;

#######
# Should:

# Read in the BLAST file found at /scratch/RNASeq/blastp.outfmt6
# Create a BLAST object for each BLAST hit
# Save each BLAST object into a hash (optional)
# Print each BLAST object by invoking the printing method
#######

# Get list of BLAST objects and print in sorted order:
my $BLAST_transcripts = read_BLAST_transcripts();
foreach my $transcript ( sort keys $BLAST_transcripts ) {
	$BLAST_transcripts->{$transcript}->print_all();
}

# Returns a hash of BLAST objects. Objects are created with data read
# in from BLAST file.
sub read_BLAST_transcripts {
	my $BLAST_file = '/scratch/RNASeq/blastp.outfmt6';
	open( BLAST_FILE, '<', $BLAST_file ) or die $!;

	# Initialize $_
	$_ = '';

	# Hash to store BLAST transcripts:
	my %BLAST_transcripts;

	# Read file and parse data of interest
	while ( my $record = <BLAST_FILE> ) {
		chomp $record;

		# Instantiate new BLAST object with new() constructor:
		my $blast = BLAST->new();

		# Invoke object's method, parse_blast_hit, to set attributes:
		$blast->parse_blast_hit($record);

		# Object must have defined 'transcript' attribute to be added to hash
		if ( defined $blast->transcript() ) {
			$BLAST_transcripts{ $blast->transcript() } = $blast;
		}
	}
	close BLAST_FILE;
	return \%BLAST_transcripts;
}
