# Makefile.PL for Module-Template-Setup

# $Id: Makefile.PL,v 1.1 2004-02-28 21:27:25 jonasbn Exp $

use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
	'AUTHOR'        => 'Jonas B. Nielsen (jonasbn) <jonasbn@cpan.org>',
    'NAME'	        => 'Module::Template::Setup',
    'VERSION_FROM'  => 'lib/Module/Template/Setup.pm', # finds $VERSION
	'PREREQ_PM' => {
		'Test::Harness'       => 0,
		'Test::More'          => 0,
	}
);
