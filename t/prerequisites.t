# http://search.cpan.org/~bdfoy/Test-Prereq/lib/Build.pm

# $Id$

## no critic (RequireEndWithOne, RequireExplicitPackage, RequireCheckingReturnValueOfEval)

use strict;
use warnings;
use Test::More;
use English qw(-no_match_vars);

our $VERSION = '0.02';

eval { require Test::Prereq; };

my $msg;

if ($EVAL_ERROR) {
    $msg = 'Test::Prereq required to test dependencies';
} elsif (not $ENV{TEST_AUTHOR}) {
    $msg = 'Author test.  Set $ENV{TEST_AUTHOR} to a true value to run.';
}

plan skip_all => $msg if $msg;

Test::Prereq::prereq_ok();
