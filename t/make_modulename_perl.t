# $Id: make_modulename_perl.t,v 1.1 2004-03-30 12:07:40 jonasbn Exp $

use strict;
use Test::More tests => 1;
use lib qw(blib/lib);
use Module::Template::Setup;

my $modulename = 'This-Is-A-Test-Module';

my $mts = Module::Template::Setup->new(modulename => $modulename);

my $modulename_perl = $mts->_make_modulename_perl();
is($modulename_perl, 'This::Is::A::Test::Module');