# Makefile.PL for Module-Template-Setup

# $Id: Makefile.PL,v 1.5 2004-03-30 16:08:43 jonasbn Exp $

use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
	'AUTHOR'        => 'Jonas B. Nielsen (jonasbn) <jonasbn@cpan.org>',
    'NAME'	        => 'Module::Template::Setup',
    'VERSION_FROM'  => 'lib/Module/Template/Setup.pm', # finds $VERSION
	'PREREQ_PM' => {
		'Test::More'          => 0,
		'Config::Simple'      => 0,
		'Cwd'                 => 0,
		'Carp'                => 0,
		'Env'                 => 0,
		'CGI::FastTemplate'   => 0,
		'Test::Pod'           => '0.95',
		'Test::Pod::Coverage' => '0.08',
		'File::Find'          => 0,
		'File::Spec'          => 0
	}
);
