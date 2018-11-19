#!/usr/bin/perl
use warnings;
use strict;
use feature 'say';

my $gtf_file  = "/Users/trish/desktop/gencode.v28lift37.annotation.gtf";

open ( GTF, '<', $gtf_file ) or die $!;

while (<GTF>) {
	chomp;
}