# $Id: make_files.t,v 1.2 2004-03-30 13:13:02 jonasbn Exp $

use strict;
use Test::More tests => 5;
use Cwd;
use lib qw(blib/lib);
use Module::Template::Setup;

my $modulename = 'This-Is-A-Test-Module';
my @files = qw(Makefile.PL Changes TODO INSTALL README);

my $mts = Module::Template::Setup->new(modulename => $modulename);

my $dir = cwd;
my $tpl = new CGI::FastTemplate("$dir/templates");
$tpl->define(
	Changes          => "Changes.tpl",
	INSTALL          => "INSTALL.tpl",
	Makefile_PL      => "Makefile_PL.tpl",
	README           => "README.tpl",
	TODO             => "TODO.tpl",
	pod_t            => "pod_t.tpl",
	'pod-coverage_t' => "pod-coverage_t.tpl",
	module_pm        => "module_pm.tpl",
	'00_load_t'      => "00_load_t.tpl",
);


mkdir($modulename);
chdir($modulename);
$mts->_make_files($tpl, @files);

foreach my $file (@files) {
	ok(-e $file && -f $file);
}

foreach my $file (@files) {
	unlink($file);
}

chdir("..");
rmdir($modulename);