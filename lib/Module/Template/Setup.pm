package Module::Template::Setup;

# $Id: Setup.pm,v 1.4 2004-03-30 08:45:53 jonasbn Exp $

use strict;
use vars qw($VERSION);
use Env qw(HOME);
use Cwd;
use Carp;
use Config::Simple;
use CGI::FastTemplate;

$VERSION = '0.01';

sub new {
	my ($class, %params) = @_;

	my $self = bless {}, $class || ref $class;

	$self->{'modulename'} 
		= $self->_handle_modulename($params{'modulename'});

	my $cfg = new Config::Simple("$HOME/.mts/mts.ini");
	$self->{'defaults'} = $self->_get_data($cfg);

	return $self;
}

sub setup {
	my ($self, %params) = @_;

	my @dirs = qw(t lib);
	my @files = qw(Makefile.PL Changes TODO INSTALL README);
	my @tests = qw(00.load.t pod-coverage.t pod.t);

	my $tpl = new CGI::FastTemplate("$HOME/.mts/templates");
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

	$tpl->assign($self->defaults);

	mkdir($self->{'modulename'});
	chdir($self->{'modulename'});
	$self->make_dirs(@dirs);
	$self->make_files($tpl, @files);
	$self->make_test_files($tpl, @tests);

	my $moduledir = getcwd();
	$self->make_module_dirs($self->{'modulename'});
	$self->make_module_file($self->{'modulename'}, $tpl);
	chdir($moduledir);

	return 1;
}

sub _get_data {
	my ($self, $cfg) = @_;

	my $modulename_perl = $self->{'modulename'};

	$modulename_perl =~ s/-/::/g;

	my @dirs = split(/::/, $modulename_perl);
	my $modulename_file = pop(@dirs);
	$modulename_file .= '.pm';

	my ($moduledirs) = join('/',@dirs);
	my $year = (localtime(time))[5] + 1900;

	my %defaults = (
		CVSTAG          => $cfg->{'cvstag'}?$cfg->{'cvstag'}:"\$Id\$",
		MODULENAME      => $self->{'modulename'},
		MODULENAME_PERL => $self->{'modulename_perl'},
		MODULENAME_FILE => $self->{'modulename_file'},
		MODULEDIRS      => $self->{'moduledirs'},
		AUTHORNAME      =>
			$cfg->{'AUTHORNAME'}?$cfg->{'AUTHORNAME'}:'',
		AUTHOREMAIL     =>
			$cfg->{'AUTHOREMAIL'}?$cfg->{'AUTHOREMAIL'}:'',
		LICENSENAME     => '',
			$cfg->{'LICENSENAME'}?$cfg->{'LICENSENAME'}:'',
		LICENSEDETAILS  => '',
			$cfg->{'LICENSEDETAILS'}?$cfg->{'LICENSEDETAILS'}:'',
		DATEYEAR        => $year,
		VERSIONNUMBER   => '0.01',
	);

	return \%defaults;
}

sub _handle_modulename {
	my ($self, $modulename) = @_;
	
	my $tmp_modulename = $modulename;
	$tmp_modulename =~ s/::/-/g; #substituting double colons
	
	#asserting modulename validity
	unless ($tmp_modulename =~ m/^([A-Za-z]+)(\w*)(?=\2|-\2)/) {
		warn ("invalid modulename: $modulename");
		return undef;
	}

	return $tmp_modulename;
}

sub _make_module_dirs {
	my ($self) = @_;

	chdir('lib');
	my @dirs = split(/-/, $self->{'modulename'});
	pop(@dirs);

	foreach my $dir (@dirs) {
		mkdir($dir);
		chdir($dir);
	}
	
	return 1;
}

sub _make_test_files {
	my ($self, $tpl, @tests) = @_;

	my $moduledir = getcwd();
	chdir('t');
	foreach my $test (@tests) {
		$self->make_file($test, $tpl);
	}
	chdir($moduledir);
	
	return 1;
}

sub _make_module_file {
	my ($self, $tpl) = @_;

	my @dirs = split(/-/, $self->{'modulename'});
	my $file = pop(@dirs);
	$file .= '.pm';

	$self->_make_file($file, $tpl, 'module_pm');

	return 1;
}

sub _make_dirs {
	my ($self, @dirs) = @_;

	foreach my $dir (@dirs) {
		mkdir($dir);
	}

	return 1;
}

sub _make_files {
	my ($self, $tpl, @files) = @_;

	foreach my $file (@files) {
		$self->_make_file($file, $tpl);
	}

	return 1;
}

sub _make_file {
	my ($self, $filename, $tpl, $template_name) = @_;

	if (! $template_name) {
		$template_name = $filename;
		$template_name =~ s/\./_/g;
		$template_name =~ s[_(w+)$][\.$1];
	}
	$tpl->assign($self->{'defaults'});
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

Module::Template::Setup - aid in setting up new modules based on templates

=head1 VERSION

Module::Template::Setup 0.01

=head1 SYNOPSIS

my $module = Module::Template::Setup->new($modulename);

$module->setup();

=head1 ABSTRACT

The goal of Module::Template::Setup is to provide a simple tool for speeding up
the proces of spawning new modules by taking away all the borrowing work of
adding all the required files and populating them with all the redundant 
information.

The module tries to combine the following parameters:

=over 4

=item templated files

=item default values

=item configurable values

=item commandline tools

=back

=head1 DESCRIPTION

=head2 METHODS

=head2 new

This is the constructor. It takes one argument a string holding the modulename
in the following format.

=head2 setup

=head2 RESERVED WORDS

=over 4

=item *

$VERSION

=back

=head1 Caveats/Bugs

When running the script, CGI::FastTemplate issues a warning, due to the
fact that some of the templates contain a scalar called: $VERSION.

Since CGI::FastTemplate does (should) not know any variables of this
name and it follows the naming convention for $placeholders to be used,
it issues the following warning-

Please refer to the list of RESERVED WORDS for more of these.

The template naming is also somewhat crazy, apparently templates names
cannot contain - (dash) or start with numbers, then they have to be
quoted.

=head1 TODO

=over 4

=item Implement handling and distinction of both global and local templates

=item Add AUTHOR file?

=item Add LICENSE file?

=item Add possibility of adding new templates and removing existing

=item Add possibility of adding new placeholders and default values

=back

=head1 SEE ALSO

=over 4

=item ExtUtils::MakeMaker

=item Module::Build

=item Module::Release

=item Test::Pod

=item Test::Pod::Coverage

=back

=head1 AUTHOR

Jonas B. Nielsen (jonasbn) - E<lt>jonasbn@cpan.orgE<gt>

=head1 COPYRIGHT

Module::Template::Setup is (C) by Jonas B. Nielsen (jonasbn) 2004

Module::Template::Setup is free software and is released
under the Artistic License. See 
L<http://www.perl.com/language/misc/Artistic.html> for details. 

=cut
