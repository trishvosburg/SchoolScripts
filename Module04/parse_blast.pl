#!/usr/bin/perl
use warnings;
use strict;
use feature qw(say);
use BLAST;

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
		my $blast = BLAST->new( BLAST_transcript => $record);

		# Object must have defined 'transcript' attribute to be added to hash
		if ( defined $blast->get_transcript() ) {
			$BLAST_transcripts{ $blast->get_transcript() } = $blast;
		}
	}
	close BLAST_FILE;
	return \%BLAST_transcripts;
}
