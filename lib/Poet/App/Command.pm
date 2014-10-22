package Poet::App::Command;
$Poet::App::Command::VERSION = '0.15';
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
