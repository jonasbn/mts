# Makefile.PL for $MODULENAME

# $CVSTAG

use ExtUtils::MakeMaker;

WriteMakefile(
	'AUTHOR'        => '$AUTHORNAME <$AUTHOREMAIL>',
    'NAME'	        => '$MODULENAME_PERL',
    'VERSION_FROM'  => 'lib/$MODULESDIRS/$MODULENAME_FILE', # finds $VERSION
	'PREREQ_PM' => {
		'Test::Harness'       => 0,
		'Test::More'          => 0,
	}
);
