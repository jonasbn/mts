# Makefile.PL for $MODULENAME

# $CVSTAG

use ExtUtils::MakeMaker;

WriteMakefile(
	'AUTHOR'        => '$AUTHORNAME $AUTHOREMAIL',
    'NAME'	        => '$MODULENAME_PERL',
    'VERSION_FROM'  => 'lib/$MODULEDIRS/$MODULENAME_FILE', # finds $VERSION
	'PREREQ_PM' => {
		'Test::More'          => 0,
		'Test::Pod'           => '0.95',
		'Test::Pod::Coverage' => '0.08',
		'File::Find'          => 0,
		'File::Spec'          => 0
	}
);
