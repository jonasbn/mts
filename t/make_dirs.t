# $Id: make_dirs.t,v 1.1 2004-03-30 12:07:40 jonasbn Exp $

use strict;
use Test::More tests => 3;
use Cwd;
use lib qw(blib/lib);
use Module::Template::Setup;

my $modulename = 'This-Is-A-Test-Module';
my @dirs = qw(lib t);

my $mts = Module::Template::Setup->new(modulename => $modulename);

mkdir($modulename);
chdir($modulename);
ok($mts->_make_dirs(@dirs));

foreach my $dir (@dirs) {
	ok(-e $dir && -d $dir);
}

foreach my $dir (@dirs) {
	rmdir($dir);
}

chdir("..");
rmdir($modulename);
