package Module::Template::Setup;

# $Id: Setup.pm,v 1.11 2004-03-31 07:38:04 jonasbn Exp $

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

	my $self = bless {
		defaults => {
			AUTHORNAME     => '',
			AUTHOREMAIL    => '',
			CVSTAG         => '',
			DATEYEAR       => '',
			LICENSENAME    => '',
			LICENSEDETAILS => '',
		},
	}, $class || ref $class;

	$self->{'defaults'}->{'MODULENAME'} 
		= $self->_handle_modulename($params{'modulename'});

	$self->{'defaults'}->{'MODULENAME_FILE'} 
		= $self->_make_modulename_file();

	$self->{'defaults'}->{'MODULENAME_PERL'} 
		= $self->_make_modulename_perl();

	@{$self->{'moduledirs'}} 
		= $self->_make_modulename_dirs();

	$self->{'defaults'}->{'MODULEDIRS'} = join('/',@{$self->{'moduledirs'}});

	my $cfg;
	if ($params{'configfile'} && -e  $params{'configfile'} && -r $params{'configfile'}) {
		
		$cfg = new Config::Simple($params{'configfile'});
	}
	$self->{'defaults'} = $self->_get_data($cfg, \%params);

	return $self;
}

sub _get_data {
	my ($self, $cfg, $params) = @_;

	my $year = (localtime(time))[5] + 1900;

	my %all_defaults;
	if ($cfg) {
		$all_defaults{'CVSTAG'} = 
			$cfg->param('CVSTAG')?$cfg->param('CVSTAG'):"\$Id\$";
		$all_defaults{'AUTHORNAME'} =
			$cfg->param('AUTHORNAME')?$cfg->param('AUTHORNAME'):'';
		$all_defaults{'AUTHOREMAIL'} =
			$cfg->param('AUTHOREMAIL')?$cfg->param('AUTHOREMAIL'):'';
		$all_defaults{'LICENSENAME'} =
			$cfg->param('LICENSENAME')?$cfg->param('LICENSENAME'):'';
		$all_defaults{'LICENSEDETAILS'} =
			$cfg->param('LICENSEDETAILS')?$cfg->param('LICENSEDETAILS'):'';
	}
	
	if ($params) {
		$all_defaults{'DATEYEAR'} =
			$params->{'YEAR'}?$params->{'YEAR'}:"$year";
		$all_defaults{'VERSIONNUMBER'} =
			$params->{'VERSIONNUMBER'}?$params->{'VERSIONNUMBER'}:'0.01';
	}

	foreach my $d (keys (%{$self->{'defaults'}})) {
		$all_defaults{$d} = $self->{'defaults'}->{$d} if ($self->{defaults}->{$d});
	}

	return \%all_defaults;
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

	$tpl->assign($self->{'defaults'});

	mkdir($self->{'defaults'}->{'MODULENAME'});
	chdir($self->{'defaults'}->{'MODULENAME'});
	$self->_make_dirs(@dirs);
	$self->_make_files($tpl, @files);
	$self->_make_test_files($tpl, @tests);

	my $moduledir = getcwd();
	$self->_make_module_dirs($self->{'defaults'}->{'MODULENAME'});
	$self->_make_module_file($self->{'defaults'}->{'MODULENAME'}, $tpl);
	chdir($moduledir);

	return 1;
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

sub _make_modulename_dirs {
	my ($self) = @_;

	my @dirs = split(/-/, $self->{'defaults'}->{'MODULENAME'});
	pop(@dirs);

	return @dirs;
}

sub _make_module_dirs {
	my ($self) = @_;

	my $moduledir = getcwd();
	chdir('lib');

	foreach my $dir (@{$self->{'moduledirs'}}) {
		mkdir($dir);
		chdir($dir);
	}
	chdir($moduledir);

	return 1;
}

sub _make_test_files {
	my ($self, $tpl, @tests) = @_;

	my $moduledir = getcwd();
	chdir('t');
	foreach my $test (@tests) {
		$self->_make_file($test, $tpl);
	}
	chdir($moduledir);
	
	return 1;
}

sub _make_modulename_file {
	my ($self) = @_;

	my @dirs = split(/-/, $self->{'defaults'}->{'MODULENAME'});
	my $file = pop(@dirs);
	if ($file) {
		$file .= '.pm';
		return $file;
	} else {
		return undef;
	}
}

sub _make_modulename_perl {
	my ($self) = @_;

	my $name = $self->{'defaults'}->{'MODULENAME'};
	$name =~ s/-/::/g;

	return $name;
}

sub _make_module_file {
	my ($self, $tpl) = @_;

	$self->_make_file($self->{'defaults'}->{'MODULENAME_FILE'}, $tpl, 'module_pm');

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
	$tpl->assign(\%{$self->{'defaults'}});
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

Module::Template::Setup - aid in setting up a module based on templates

=head1 VERSION

Module::Template::Setup 0.01

=head1 SYNOPSIS

my $module = Module::Template::Setup->new($modulename);

$module->setup();

=head1 ABSTRACT

The goal of Module::Template::Setup is to provide a simple tool for speeding up
the proces of spawning new modules by taking away all the boring work of
adding all the required files and populating them with all the redundant 
information.

The module aims to combine the following parameters:

=over 4

=item * templated files

=item * default values

=item * configurable values

=item * commandline arguments

=back

Module::Template::Setup is currently in B<alpha> and requires a lot of
work (please see the B<TODO> below).

=head1 DESCRIPTION

=head2 METHODS

=head3 new

This is the constructor. It takes one argument a string holding the modulename
in either of the following formats:

=over 4

=item * Modulename

=item * Module::Name

=item * Module-Name

=back

=head3 setup

This method does the actual work, based on the initialized object:

=over 4

=item 1. Creates a root directory named after the specified module (SEE: B<new>)

=item 2. Creates sub directories (SEE: B<DIRECTORIES>)

=item 3. Populates root directory with files based on templates 
(SEE: B<TEMPLATES>)

=item 4. Creates and module directory structure in the B<lib> directory
(SEE: B<DIRECTORIES>)

=item 5. Populates the module directory structure in the B<lib> directory with
a file based on a template (SEE: B<TEMPLATES>)

=back

=head2 RESERVED WORDS

Reserverd words are a list of names, which are not suitable as template placeholders.

=over 4

=item * $VERSION

=back

I<more will follow...>

=head2 DIRECTORIES

The following directories are always built:

=over 4

=item * Module-Name (this directory acts as root directory for everything else)

=item * t (for tests)

=item * lib (for the module)

=back

=head2 TEMPLATES

The following templates are used to populate the directories.

In the root directory:

=over 4

=item Changes.tpl

=item INSTALL.tpl

=item README.tpl

=item TODO.tpl

=item t (directory)

=over 4

=item 00_load_t.tpl

=item pod_t.tpl

=item pod-coverage_t.tpl

=back

=item lib (directory)

=over 4

=item E<lt>ModulenameE<gt>_pm.tpl

placed in the appropriate sub directory based on module name (SEE: B<setup>).

=back

=back

If you are not satisfied with the population of the templates, you can
edit the templates to suit your needs.

Example: if you prefer the Perl modulenaming convention with '::' instead of the
filesystem convention with -, you can just exchange $MODULENAME with 
$MODULENAME_PERL.

=head2 DEFAULTS

These are some of the defined defaults values for the PLACEHOLDERS used in the 
TEMPLATES.

=over 4

=item * CVSTAG is set to B<\$Id\$> 

=item * DATEYEAR is set to current year (for copyright notice)

=item * VERSIONNUMBER defaults to 0.01

=back

=head2 PLACEHOLDERS

Apart from the values mentioned in DEFAULTS (above) this is a list of the current 
placeholders, which can be set.

=over 4

=item AUTHORNAME

Should be set in you configuration file

=item AUTHOREMAIL

Should be set in you configuration file

=item MODULENAME

This is comes from the argument given to the constructor

=item MODULENAME_PERL

This is auto-resolved from the MODULENAME

=item MODULENAME_FILE

This is auto-resolved from the MODULENAME

=item MODULEDIRS

This is auto-resolved from the MODULENAME

=item LICENSENAME

Should be set in your configuration file

=item LICENSEDETAILS

Should be set in your configuration file

=back

=head1 CAVEATS

When running the script, CGI::FastTemplate issues a warning, due to the
fact that some of the templates contain a scalar called: $VERSION.

Since CGI::FastTemplate does (should) not know any variables of this
name and it follows the naming convention for $placeholders to be used,
it issues the following warning-

Please refer to the list of RESERVED WORDS for more of these.

The template naming is also somewhat crazy, apparently templates names
cannot contain - (dash) or start with numbers, then they have to be
quoted.

=head1 BUGS

There are no known bugs at the time of writing, if you experience any bugs,
please report them using the following email address:

E<lt>bug-module-template-setup@rt.cpan.orgE<gt>

Feedback also welcome on this address or directly to me on the address below (SEE: B<AUTHOR>).

=head1 TODO

=over 4

=item Implement handling and distinction of both global and local templates

=item Add AUTHOR file?

=item Add LICENSE file?

=item Add possibility of adding new templates and removing existing

=item Add possibility of adding new placeholders and default values

=item Add handling of several standard licenses

=item Add handling of setup targets of ExtUtils::MakeMaker or Module::Build

=item Add bug reporting address?

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
