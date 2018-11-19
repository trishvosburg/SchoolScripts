#!/usr/bin/perl
use warnings;
use strict;
use DBI;
use feature 'say';

my ( $dbh, $sth, $id, $synonym);

$dbh = DBI->connect( 'dbi:mysql:go', 'vosburg.p', 'Bio6200MySQL' )
  || die "Error opening database: $DBI::errstr\n";
  
# Query table for specific id:
$sth = $dbh->prepare( "SELECT term_id, term_synonym FROM term_synonym WHERE term_id = 42952;" ) 
	|| die "Prepare failed: $DBI::errstr\n";

$sth->execute()
  || die "Couldn't execute query: $DBI::errstr\n";

while ( ( $id, $synonym ) = $sth->fetchrow_array ) {
	say "$synonym for $id: $synonym";
}

$sth->finish();

$dbh->disconnect || die "Failed to disconnect\n";
