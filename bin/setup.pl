#!/usr/bin/perl -w

# $Id: setup.pl,v 1.2 2004-02-29 23:35:44 jonasbn Exp $

use strict;
use XML::Conf;
use CGI::FastTemplate;

my @dirs = qw(t lib);
my @files = qw(Makefile.PL Changes TODO INSTALL README);

my $tpl = new CGI::FastTemplate("/Users/jonasbn/Develop/cvs-logicLAB/modules/Module-Template-Setup/templates");
$tpl->define(
	Changes        => "Changes.tpl",
	INSTALL        => "INSTALL.tpl",
	Makefile_PL    => "Makefile_PL.tpl",
	README         => "README.tpl",
	TODO           => "TODO.tpl",
	pod_t          => "pod_t.tpl",
	pod_coverage_t => "pod_coverage_t.tpl",
	module_pm      => "module_pm.tpl",
);


my $modulename = $ARGV[0];
my $defaults = get_data($modulename);

$tpl->assign($defaults);

mkdir($modulename);
chdir($modulename);
make_dirs(@dirs);
make_files($tpl, $defaults, @files);
make_module_dirs($modulename);
make_module_file($modulename, $tpl, $defaults);

exit(0);

sub get_data {
	my $modulename = shift;

	my $m = $modulename;
	my ($modulename_perl) = $m =~ s/-/::/g;
	my @dirs = split(/::/, $modulename_perl);
	my $modulename_file = pop(@dirs);
	$modulename_file .= '.pm';

	my ($moduledirs) = join('/',@dirs);
	my $year = (localtime(time))[5] + 1900;

	my %defaults = (
		CVSTAG          => "\$Id\$",
		MODULENAME      => $modulename,
		MODULENAME_PERL => $modulename_perl,
		MODULENAME_FILE => $modulename_file,
		MODULEDIRS      => $moduledirs,
		AUTHORNAME      => 'Jonas B. Nielsen (jonasbn)',
		AUTHOREMAIL     => '<jonasbn@cpan.org>',
		LICENSENAME     => '',
		LICENSEDETAILS  => '',
		DATEYEAR        => $year,
		VERSIONNUMBER   => '0.01',
	);

	return \%defaults;
}

sub make_module_dirs {
	my $modulename = shift;
	
	chdir('lib');
	my @dirs = split(/-/, $modulename);
	pop(@dirs);

	foreach my $dir (@dirs) {
		mkdir($dir);
		chdir($dir);
	}
	
	return 1;
}

sub make_module_file {
	my ($modulename, $tpl, $defaults) = @_;

	my @dirs = split(/-/, $modulename);
	my $file = pop(@dirs);
	$file .= '.pm';

	make_file($file, $tpl, $defaults, 'module_pm');

	return 1;
}

sub make_dirs {
	my @dirs = @_;

	foreach my $dir (@dirs) {
		mkdir($dir);
	}

	return 1;
}

sub make_files {
	my ($tpl, $defaults, @files) = @_;

	foreach my $file (@files) {
		make_file($file, $tpl, $defaults);
	}

	return 1;
}

sub make_file {
	my ($filename, $tpl, $defaults, $template_name) = @_;

	if (! $template_name) {
		$template_name = $filename;
		$template_name =~ s/\./_/;
		$template_name =~ s[_(w+)$][\.$1];
	}
	$tpl->assign($defaults);
	$tpl->parse($template_name => "$template_name");
	my $content = $tpl->fetch($template_name);

	open(FOUT, ">$filename");
	print FOUT  $$content;
	close(FOUT);

	return 1;
}

1;

__END__

=head1 NAME

setup.pl -

=head1 SYNOPSIS

=head1 ABSTRACT

=head1 DESCRIPTION

=head2 RESERVED WORDS

=over 4

=item *

$VERSION

=back

=head1 BUGS

When running the script, CGI::FastTemplate issues a warning, due to the
face that some of the templates contain a scalar called: $VERSION.

Since CGI::FastTemplate does (should) not know any variables of this
name and it follows the naming convention for $placeholders to be used,
it issues the following warning-

Please refer to the list of RESERVED WORDS for more of these.

=head1 SEE ALSO

=head1 AUTHOR

Jonas B. Nielsen (jonasbn) - <jonasbn@cpan.org>

=head1 COPYRIGHT

Module::Template::Setup is (C) by Jonas B. Nielsen (jonasbn) 2004

Module::Template::Setup is released under ???

=cut