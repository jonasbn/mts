#!/usr/bin/perl -w

# $Id: setup.pl,v 1.6 2004-03-31 07:38:04 jonasbn Exp $

use strict;
use lib qw(lib ../lib);
use Module::Template::Setup;

my $modulename = $ARGV[0];

my $mts = Module::Template::Setup->new(modulename => $modulename);
$mts->setup();

exit(0);

__END__

=head1 NAME

setup.pl -

=head1 SYNOPSIS

=head1 ABSTRACT

=head1 DESCRIPTION

=head1 BUGS

=head1 SEE ALSO

=over 4

=item *

Module::Template::Setup

=back

=head1 AUTHOR

Jonas B. Nielsen (jonasbn) - <jonasbn@cpan.org>

=head1 COPYRIGHT

Module::Template::Setup is (C) by Jonas B. Nielsen (jonasbn) 2004

Module::Template::Setup is released under ???

=cut
