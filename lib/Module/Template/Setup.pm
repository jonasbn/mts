package Module::Template::Setup;

# $Id: Setup.pm,v 1.3 2004-03-29 14:24:10 jonasbn Exp $

use strict;
require Exporter;
use vars qw($VERSION @ISA @EXPORT_OK);
use Env qw(HOME);
use Config::Simple;
use Cwd;
use CGI::FastTemplate;

$VERSION = '0.01';
@ISA = qw(Exporter);
@EXPORT_OK = qw(setup);

sub setup {
	my $modulename = shift;
	
	my @dirs = qw(t lib);
	my @files = qw(Makefile.PL Changes TODO INSTALL README);
	my @tests = qw(00.load.t pod-coverage.t pod.t);

	my $tpl = new CGI::FastTemplate("blib/templates");
	$tpl->define(
		Changes          => "Changes.tpl",
		INSTALL          => "INSTALL.tpl",
		Makefile_PL      => "Makefile_PL.tpl",
		README           => "README.tpl",
		TODO             => "TODO.tpl",
		pod_t            => "pod_t.tpl",
		'pod-coverage_t' => "pod-coverage_t.tpl",
		module_pm        => "module_pm.tpl",
		'00_load_t'      => "00_load_t.tpl",
	);

	my $defaults = get_data($modulename);

	$tpl->assign($defaults);

	mkdir($modulename);
	chdir($modulename);
	make_dirs(@dirs);
	make_files($tpl, $defaults, @files);
	make_test_files($tpl, $defaults, @tests);

	my $moduledir = getcwd();
	make_module_dirs($modulename);
	make_module_file($modulename, $tpl, $defaults);
	chdir($moduledir);

	return 1;
}

sub get_data {
	my $modulename = shift;

	my $modulename_perl = $modulename;

	$modulename_perl =~ s/-/::/g;

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

sub make_test_files {
	my ($tpl, $defaults, @tests) = @_;

	my $moduledir = getcwd();
	chdir('t');
	foreach my $test (@tests) {
		make_file($test, $tpl, $defaults);
	}
	chdir($moduledir);
	
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
		$template_name =~ s/\./_/g;
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

Module::Template::Setup -

=head1 SYNOPSIS

=head1 ABSTRACT

=head1 DESCRIPTION

=head2 RESERVED WORDS

=over 4

=item *

$VERSION

=back

=head1 Caveats/Bugs

When running the script, CGI::FastTemplate issues a warning, due to the
face that some of the templates contain a scalar called: $VERSION.

Since CGI::FastTemplate does (should) not know any variables of this
name and it follows the naming convention for $placeholders to be used,
it issues the following warning-

Please refer to the list of RESERVED WORDS for more of these.

The template naming is also somewhat crazy, apparently templates names
cannot contain - (dash) or start with numbers, then they have to be
quoted.

=head1 SEE ALSO

=head1 AUTHOR

Jonas B. Nielsen (jonasbn) - <jonasbn@cpan.org>

=head1 COPYRIGHT

Module::Template::Setup is (C) by Jonas B. Nielsen (jonasbn) 2004

Module::Template::Setup is released under ???

=cut
