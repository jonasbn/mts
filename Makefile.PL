# Makefile.PL for Module-Template-Setup

# $Id: Makefile.PL,v 1.2 2004-03-29 14:24:10 jonasbn Exp $

use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
	'AUTHOR'        => 'Jonas B. Nielsen (jonasbn) <jonasbn@cpan.org>',
    'NAME'	        => 'Module::Template::Setup',
    'VERSION_FROM'  => 'lib/Module/Template/Setup.pm', # finds $VERSION
	'PREREQ_PM' => {
		'Test::Harness'       => 0,
		'Test::More'          => 0,
		'Config::Simple'      => 0,
		'Cwd'                 => 0,
		'Env'                 => 0,
		'CGI::FastTemplate'   => 0,
		'Test::Pod'           => '0.95',
		'Test::Pod::Coverage' => '0.08',
	}
);
