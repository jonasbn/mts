# $Id: make_modulename_file.t,v 1.1 2004-03-30 12:07:40 jonasbn Exp $

use strict;
use Test::More tests => 1;
use Cwd;
use lib qw(blib/lib);
use Module::Template::Setup;

my $modulename = 'This-Is-A-Test-Module';

my $mts = Module::Template::Setup->new(modulename => $modulename);

my $m = $mts->_make_modulename_file();
$modulename =~ m/-([A-Za-z0-9_]+)$/;
my $filename = $1;
print STDERR "We produced: $filename\n";

like($m, qr/^$filename\.pm$/);
