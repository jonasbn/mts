# $Id: make_test_files.t,v 1.3 2004-03-30 13:21:43 jonasbn Exp $

use strict;
use Test::More tests => 3;
use Cwd;
use lib qw(blib/lib);
use Module::Template::Setup;

my $modulename = 'This-Is-A-Test-Module';
my @tests = qw(00.load.t pod-coverage.t pod.t);

my $mts = Module::Template::Setup->new(modulename => $modulename);

my $dir = cwd;
my $tpl = new CGI::FastTemplate("$dir/templates");
$tpl->define(
	pod_t            => "pod_t.tpl",
	'pod-coverage_t' => "pod-coverage_t.tpl",
	'00_load_t'      => "00_load_t.tpl",
);


mkdir($modulename);
chdir($modulename);
$mts->_make_test_files($tpl, @tests);

foreach my $test (@tests) {
	ok(-e $test && -f $test);
}

foreach my $test (@tests) {
	unlink($test);
}

chdir("..");
rmdir($modulename);