#!/usr/bin/perl
use warnings;
use strict;
use DBI;
use feature 'say';

# Prompts user for GO term ID, queries the 'term' table for that ID,
# and then displays the name back to the user.

# Declare variables
my ( $dbh, $sth, $id, $name );

# Connect to the go table or give helpful error message:
$dbh = DBI->connect( 'dbi:mysql:go', 'vosburg.p', 'Bio6200MySQL' )
  || die "Error opening database: $DBI::errstr\n";

# Initialize $_:
$_ = "";

# Until the user presses q, keep asking for user input for id:
until (/^q/i) {
	print "Enter a term ID (or press q to exit): ";
	chomp( $_ = <STDIN> );
	checknumber();
}

# Disconnect
$dbh->disconnect || die "Failed to disconnect\n";

# Subroutine to check to see if the input is numeric:
sub checknumber {
	if ( $_ =~ /^\d/ ) {
		executequery();

	# If the input is not numeric or q|Q, give helpful message:
	} elsif ( $_ =~ /[^q|Q]/ ) {
		say "IDs must consist of only numbers.\n";

	# Otherwise, say goodbye and exit:
	} else {
		say "Bye!";
	}
}

# Subroutine to execute the query:
sub executequery {

	# Query table for specific id:
	$sth = $dbh->prepare("SELECT id, name FROM term WHERE id = $_;")
	  || die "ID not found in system.";

	# Execute query:
	$sth->execute();
	( $id, $name ) = $sth->fetchrow_array;

	# If the variables are defined, print them:
	if ( defined $id && $name ) {
		say "ID: $id";
		say "Name: $name\n";

	# Otherwise, give helpful message:
	} else {
		say "ID not found. \n";
	}
	$sth->finish();
}
