# $Id: get_data.t,v 1.2 2004-03-30 13:21:43 jonasbn Exp $

use strict;
use Test::More tests => 3;
use lib qw(blib/lib);
use Module::Template::Setup;

my $modulename = 'This-Is-A-Test-Module';
my $mts = Module::Template::Setup->new(modulename => $modulename);

my $defaults;
ok($defaults = $mts->_get_data());

is((keys %{$defaults}), 11);

