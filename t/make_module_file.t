# $Id: make_module_file.t,v 1.5 2004-03-30 14:51:15 jonasbn Exp $

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

ok(-e $mts->{'defaults'}->{'MODULENAME_FILE'} && -f $mts->{'defaults'}->{'MODULENAME_FILE'});

unlink($mts->{'defaults'}->{'MODULENAME_FILE'});
chdir("..");
rmdir($modulename);