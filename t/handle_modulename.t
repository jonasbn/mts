use strict;
use Test::More tests => 9;
use lib qw(blib);
use Module::Template::Setup;

my $t = 1;

my @modulenames = qw(
	B
	Shortname
	A::Little::Longer
	This::Is::A::Long::Module::Name
);

foreach my $modulename (@modulenames) {
	print "test ++$t\n";
	ok(Module::Template::Setup::_handle_modulename(undef, $modulename));
}

my @badmodulenames = qw(
	_argle
	-bargle
	0
	11glop
	11glop::14
);

foreach my $modulename (@badmodulenames) {
	print "test ++$t\n";
	my $m = Module::Template::Setup::_handle_modulename(undef, $modulename);
	is($m, undef);
}
