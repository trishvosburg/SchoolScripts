#!/usr/bin/perl
#ed.plx
use strict;
use warnings;

# HTTP protocol requires that two linefeeds separate the headers from any 
# actual content. Send a text/html content type header to tell browser
# that what follows is HTML (specified by MIME type, Multipurpose
# Internet Mail Extension, consists of a category and a specific
# type within the category).
# If anything other than a header is seen by server, may cause error:
print "Content-type: text/html\n\n";

# If line isn't included, page title will be given a default name:
print "<html><head><title>Environment Dumper </title></head><body>";

# Exclusively printing out %ENV hash:
# Script iterates over contents of %ENV hash, puts the variables and 
# corresponding values into a formatted table, and passes this table
# to the client browser for us to view as a web page.
print "<center><table border=1>";
foreach (sort keys %ENV) {
	print "<tr><td>$_</td><td>$ENV{$_}</td></tr>"
}
print "</table></center></body></html>";