# $Id: make_module_file.t,v 1.3 2004-03-30 13:21:43 jonasbn Exp $

use strict;
use Test::More tests => 2;
use Cwd;
use lib qw(blib/lib);
use Module::Template::Setup;

my $modulename = 'This-Is-A-Test-Module';

my $mts = Module::Template::Setup->new(modulename => $modulename);

my $dir = cwd;
my $tpl = new CGI::FastTemplate("$dir/templates");
$tpl->define(
	module_pm        => "module_pm.tpl",
);
	
mkdir($modulename);
chdir($modulename);

ok($mts->_make_module_file($tpl));

ok(-e $mts->{modulename_file} && -f $mts->{modulename_file});

chdir("..");
rmdir($modulename);