# Build.PL

# $Id$

use strict;
use Module::Build;

my $build = Module::Build->new(
    dist_author          => 'Jonas B. Nielsen, <jonasbn@cpan.org>',
    module_name          => 'Module::Template::Setup',
    license              => 'artistic',
    recursive_test_files => 1,
    create_makefile_pl => 'traditional',
    create_readme        => 1,
    configure_requires   => {},
    requires => {
		'Test::More'          => 0,
		'Config::Simple'      => 0,
		'Cwd'                 => 0,
		'Carp'                => 0,
		'Env'                 => 0,
		'CGI::FastTemplate'   => 0,
		'Test::Pod'           => '0.95',
		'Test::Pod::Coverage' => '0.08',
		'File::Find'          => 0,
		'File::Spec'          => 0,
		'Test::Prereq'        => 0,
    },
    meta_merge => {
        resources => {
            homepage => 'http://logiclab.jira.com/wiki/display/MTS/Home',
            bugtracker =>
                'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Module-Template-Setup',
            repository => 'http://logicLAB.jira.com/svn/MTS',
            ProjectChangelog =>
                'http://logiclab.jira.com/browse/MTS#selectedTab=com.atlassian.jira.plugin.system.project%3Achangelog-panel',
            ProjectSite => 'http://logicLAB.jira.com/browse/MTS',
            ProjectWiki => 'http://logiclab.jira.com/wiki/display/MTS/Home',
        }
    },

);

$build->create_build_script();
