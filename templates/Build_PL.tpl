# Build.PL for $MODULENAME

# $CVSTAG

use Module::Build;
my $build = Module::Build->new(
	dist_author       => '$AUTHORNAME <$AUTHOREMAIL>',
	module_name       => '$MODULENAME_PERL',
	dist_version_from => 'lib/$MODULEDIRS/$MODULENAME_FILE',
	license           => '$LICENSE',
);
$build->create_build_script;
