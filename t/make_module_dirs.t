# $Id: make_module_dirs.t,v 1.4 2004-03-31 10:48:55 jonasbn Exp $

use strict;
use Test::More tests => 5;
use Cwd;
use lib qw(blib/lib);
use Module::Template::Setup;

#preparing
my $modulename = 'This-Is-A-Test-Module';
my $rootdir = getcwd();

my $mts = Module::Template::Setup->new(modulename => $modulename);

mkdir($modulename);
chdir("$modulename");
mkdir('lib');

# test 1
my @dirs = $mts->_make_modulename_dirs();
ok($mts->_make_module_dirs());

chdir("$rootdir");
chdir("$modulename");
chdir('lib');

#test 2-5
foreach my $dir (@dirs) {
	ok(-e $dir && -d $dir);
	chdir($dir);
}

#cleaning
my @reverse_dirs = reverse(@dirs);
foreach my $dir (@reverse_dirs) {
	chdir("..");
	rmdir($dir);
}
chdir("..");
rmdir('lib');
chdir($rootdir);
rmdir($modulename);
