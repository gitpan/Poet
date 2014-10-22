package Poet::App::Command::script;
$Poet::App::Command::script::VERSION = '0.14';
use File::Spec::Functions qw(rel2abs);
use Poet::Tools qw(write_file);
use Poet::Moose;
use Poet::Types;

extends 'Poet::App::Command';

method abstract () {
    "Create a Poet script";
}

method usage_desc () {
    return "poet script <script-name>";
}

method execute ($opt, $args) {
    $self->usage_error("takes one argument (script name)") unless @$args == 1;
    my ($path) = @$args;
    my $poet = $self->initialize_environment();
    $path =~ s|^bin/||;
    $path = rel2abs( $path, $poet->bin_dir() );
    die "'$path' already exists, will not overwrite" if -e $path;
    write_file( $path, $self->script_template() );
    chmod( 0775, $path );
    print "$path\n";
}

method script_template () {
    '#!/usr/local/bin/perl
use Poet::Script qw($conf $poet);
use strict;
use warnings;

';
}

1;
