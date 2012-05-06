package Poet::App::Command;
BEGIN {
  $Poet::App::Command::VERSION = '0.07';
}
use Poet::Moose;
use Cwd qw(getcwd);
use strict;
use warnings;

method initialize_environment () {
    require Poet::Script;
    Poet::Script::initialize_with_root_dir( getcwd() );
}

extends 'MooseX::App::Cmd::Command';

1;
