# $Id: licenses.t,v 1.1 2004-05-15 14:30:16 jonasbn Exp $

use strict;
use lib qw(lib);
use vars qw(%licenses);
use Test::More tests => 1;

use_ok('Module::Template::Setup::Licenses', qw(%licenses));
