#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

say "Content-type: text/plain\n";
say "Hello CGI World!\n";

say "REMOTE_ADDR:";
say $ENV{REMOTE_ADDR};
say "\n";
say "SCRIPT_NAME:";
say $ENV{SCRIPT_NAME};
say "\n";
say "SERVER_NAME:";
say $ENV{SERVER_NAME};
say "\n";
say "REQUEST_METHOD:";
say $ENV{REQUEST_METHOD};
say "\n";
say "SCRIPT_FILENAME:";
say $ENV{SCRIPT_FILENAME};
say "\n";
say "SERVER_SOFTWARE:";
say $ENV{SERVER_SOFTWARE};
say "\n";
say "QUERY_STRING:";
say $ENV{QUERY_STRING};
say "\n";
say "CONTEXT_DOCUMENT_ROOT:";
say $ENV{CONTEXT_DOCUMENT_ROOT};
say "\n";
say "REQUEST_URI:";
say $ENV{REQUEST_URI};