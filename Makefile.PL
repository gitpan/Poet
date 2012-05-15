
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;

use File::ShareDir::Install;
install_share dist => "share";


my %WriteMakefileArgs = (
  'ABSTRACT' => 'The Mason web framework',
  'AUTHOR' => 'Jonathan Swartz <swartz@pobox.com>',
  'BUILD_REQUIRES' => {
    'Test::Class::Most' => '0',
    'Test::WWW::Mechanize::PSGI' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.30',
    'File::ShareDir::Install' => '0.03'
  },
  'DISTNAME' => 'Poet',
  'EXE_FILES' => [
    'bin/poet'
  ],
  'LICENSE' => 'perl',
  'NAME' => 'Poet',
  'PREREQ_PM' => {
    'CHI' => '0.52',
    'Capture::Tiny' => '0',
    'File::ShareDir' => '0',
    'File::ShareDir::Install' => '0',
    'File::Slurp' => '0',
    'File::Spec::Functions' => '0',
    'Guard' => '0',
    'JSON::XS' => '0',
    'Log::Any::Adapter' => '0',
    'Mason' => '2.19',
    'Mason::Plugin::Cache' => '0',
    'Mason::Plugin::HTMLFilters' => '0',
    'Mason::Plugin::RouterSimple' => '0.05',
    'Method::Signatures::Simple' => '1.02',
    'Moose' => '1.15',
    'MooseX::App::Cmd' => '0',
    'MooseX::HasDefaults::RO' => '0',
    'MooseX::StrictConstructor' => '0',
    'Plack' => '0',
    'Plack::Middleware::Session' => '0',
    'Plack::Session::Store::Cache' => '0',
    'Try::Tiny' => '0',
    'URI' => '0',
    'URI::Escape' => '0',
    'YAML::XS' => '0'
  },
  'VERSION' => '0.09',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

package
MY;
use File::ShareDir::Install qw(postamble);


