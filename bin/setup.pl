#!/usr/bin/perl -w

# $Id: setup.pl,v 1.1 2004-02-28 21:27:25 jonasbn Exp $

use strict;
use XML::Conf;
use CGI::FastTemplate;

my @dirs = qw(t lib);
my @files = qw(Makefile.PL Changes TODO INSTALL README);

my $tpl = new CGI::FastTemplate("templates");
$tpl->define(
	Changes        => "Changes.tpl",
	INSTALL        => "INSTALL.tpl",
	Makefile_PL    => "Makefile_PL.tpl",
	README         => "README.tpl",
	TODO           => "TODO.tpl",
	pod_t          => "pod_t.tpl",
	pod_coverage_t => "pod_coverage_t.tpl",
);


my $modulename = $ARGV[0];
my $defaults = get_data();

$tpl->assign($defaults);

mkdir($modulename);
chdir($modulename);
make_dirs(@dirs);
make_files($tpl, $defaults, @files);
make_module_dirs($modulename);
make_module_file($modulename, $tpl, $defaults);

exit(0);

sub get_data {
	my $modulename = shift;

	my %defaults = (
		CVSTAG          => '$Id: setup.pl,v 1.1 2004-02-28 21:27:25 jonasbn Exp $',
		MODULENAME      => $modulename,
		AUTHORNAME      => 'Jonas B. Nielsen (jonasbn)',
		AUTHOREMAIL     => '<jonasbn@cpan.org>',
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

sub make_module_file {
	my ($modulename, $tpl, $defaults) = @_;

	my @dirs = split(/-/, $modulename);
	my $file = pop(@dirs);
	$file .= '.pm';

	make_file($file, $tpl, $defaults);

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
	my ($filename, $tpl, $defaults) = @_;

	#system("touch $filename");
	$file_name =~ s[_(w+)$][\.$1];
	my ($template_name) = $filename =~ m/($filename).tpl$/;
	$template_name =~ tr/a-z/A-Z/;

	$tpl->assign($defaults);
	$tpl->parse($template_name);
	my $content = $tpl->fetch($template_name);

	open(FOUT, ">$filename");
	print FOUT  $$content;
	close(FOUT);

	return 1;
}

1;

__END__
