# $Id: make_module_dirs.t,v 1.2 2004-03-30 13:13:02 jonasbn Exp $

use strict;
use Test::More tests => 5;
use Cwd;
use lib qw(blib/lib);
use Module::Template::Setup;

my $modulename = 'This-Is-A-Test-Module';
my $rootdir = getcwd();

my $mts = Module::Template::Setup->new(modulename => $modulename);

mkdir($modulename);
chdir("$modulename");

my @dirs = $mts->_make_modulename_dirs();

ok($mts->_make_module_dirs());

chdir('lib');
foreach my $dir (@dirs) {
	ok(-e $dir && -d $dir);
	chdir($dir);
}

my @reverse_dirs = reverse(@dirs);
foreach my $dir (@reverse_dirs) {
	print STDERR "dir = $dir\n";
	chdir("..");
	rmdir($dir);
}

chdir($rootdir);
rmdir($modulename);
