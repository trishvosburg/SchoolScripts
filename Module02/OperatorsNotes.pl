#usr/bin/perl
use warnings;
use strict;
use feature qw(say);


## Defined-or Operator //
# Tests whether the operand on the left is defined, not if it's true. 
# This means that the number zero and an empty string will still evaluate to true when compared with //. 
# In plain speech: is the thing on the left defined? If it's not, print NA, if it is defined, print what it is
# If the lefthand operator is not defined, then perl will execute the code on the right:

my $not_defined;
#say $not_defined // 'NA';
# Evaluates to false, printed NA

my $empty_string = '';
#say $empty_string // 'NA';
# Evaluated to true, printed contents ()

my $zero_value = 0;
#say $zero_value // 'NA';
# Evaluated to true, printed contents (0)


## Logical-or Operator || 
# Tests whether the left operand is true (as opposed to defined)
# In plain speech: is the thing on the left true? If it's true, print what it is, if it's false, print NA.

my $not_defined1;
#say $not_defined1 || 'NA';
# Evaluates to false, printed NA

my $empty_string1 = '';
#say $empty_string1 || 'NA';
# Evaluates to false, printed NA

my $zero_value1 = 0;
#say $zero_value1 || 'NA';
# Evaluates to false, printed NA


## Ternary Operator ?:
# Takes in 3 operands
# Perl will evaluate the first operand in boolean context (hence the ?, as in to ask "is this true?")
# If it evaluates to true, second operand comes into play
# if false, then the third operand comes into play
# In plain speech: if the first operand is true, then use the second operand, else use the third operand

my $not_defined2;
say $not_defined2 ? 'yayyyy' : 'NA';
# Evaluates to false, so uses third operand
