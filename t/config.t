# $Id: config.t,v 1.1 2004-03-30 16:08:43 jonasbn Exp $

use strict;
use Test::More tests => 4;
use lib qw(blib/lib);
use Module::Template::Setup;

my $modulename = 'This-Is-A-Test-Module';
my $mts = Module::Template::Setup->new(
	modulename => $modulename,
	configfile => "etc/mts.ini",
);

ok(ref $mts);

like($mts->{'defaults'}->{'AUTHORNAME'}, qr/\w+/);
like($mts->{'defaults'}->{'AUTHOREMAIL'}, qr/@/);

is((keys %{$mts->{'defaults'}}), 11);