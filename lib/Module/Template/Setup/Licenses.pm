package Module::Template::Setup::Licenses;

# $Id: Licenses.pm,v 1.1 2004-05-15 14:29:17 jonasbn Exp $

use strict;
require Exporter;
use vars qw($VERSION @EXPORT_OK @ISA %licenses);

$VERSION = '0.01';
@ISA = qw(Exporter);
@EXPORT_OK = qw(%licenses);

%licenses = (
gpl => 
"The distribution is distributed under the terms of the Gnu General
Public License\n(http://www.opensource.org/licenses/gpl-license.php).",
lgpl => 
"The distribution is distributed under the terms of the Gnu Lesser
General Public
License\n(http://www.opensource.org/licenses/lgpl-license.php).",
artistic => 
"The distribution is licensed under the Artistic License, as specified
by the Artistic file in the standard perl distribution\n(http://www.perl.com/language/misc/Artistic.html).",
bsd => 
"The distribution is licensed under the BSD
License\n(http://www.opensource.org/licenses/bsd-license.php)."
);

1;

__END__

=head1 NAME

Module::Template::Setup::Licenses - licenses and their respective descriptions

=head1 VERSION

Module::Template::Setup::License 0.01

=head1 SEE ALSO

=over 4

=item Module::Build

=item Module::Template::Setup

=back

=head1 AUTHOR

Jonas B. Nielsen (jonasbn) - E<lt>jonasbn@cpan.orgE<gt>

=head1 COPYRIGHT

Module::Template::Setup::License is (C) by Jonas B. Nielsen (jonasbn) 2004

Module::Template::Setup::License is free software and is released
under the Artistic License. See 
L<http://www.perl.com/language/misc/Artistic.html> for details. 

=cut