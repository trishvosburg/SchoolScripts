#!/usr/bin/perl
use warnings;
use strict;
use DBI;
use feature 'say';

# Reads one of the GO tables programmatically rather than in MYSQL

my ( $dbh, $sth, $id, $synonym );

$dbh = DBI->connect( 'dbi:mysql:go', 'vosburg.p', 'Bio6200MySQL' )
  || die "Error opening database: $DBI::errstr\n";

$sth = $dbh->prepare("SELECT * FROM term_synonym;")
  || die "Prepare failed: $DBI::errstr\n";

$sth->execute()
  || die "Couldn't execute query: $DBI::errstr\n";

while ( ( $id, $synonym ) = $sth->fetchrow_array ) {
	say "$synonym has ID $id";
}

$sth->finish();

$dbh->disconnect || die "Failed to disconnect\n";
