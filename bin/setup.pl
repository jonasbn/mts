#!/usr/bin/perl -w

# $Id: setup.pl,v 1.5 2004-03-30 08:45:53 jonasbn Exp $

use strict;
use lib qw(lib ../lib);
use Module::Template::Setup qw(setup);

my $modulename = $ARGV[0];

setup($modulename);

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
