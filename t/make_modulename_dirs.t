# $Id: make_modulename_dirs.t,v 1.1 2004-03-30 12:07:40 jonasbn Exp $

use strict;
use Test::More tests => 4;
use lib qw(blib/lib);
use Module::Template::Setup;

my $modulename = 'This-Is-A-Test-Module';

my $mts = Module::Template::Setup->new(modulename => $modulename);

my @dirs = $mts->_make_modulename_dirs();

my @parts = split(/-/, $modulename);

my $i = 0;
foreach my $dir (@dirs) {
	is($dir, $parts[$i++]);
}
