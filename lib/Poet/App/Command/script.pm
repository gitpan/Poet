package Poet::App::Command::script;
BEGIN {
  $Poet::App::Command::script::VERSION = '0.03';
}
use File::Spec::Functions qw(rel2abs);
use Poet::Util qw(write_file);
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
    my $env = $self->initialize_environment();
    $path =~ s|^bin/||;
    $path = rel2abs( $path, $env->bin_dir() );
    die "'$path' already exists, will not overwrite" if -e $path;
    write_file( $path, $self->script_template() );
    chmod( 0775, $path );
    print "$path\n";
}

method script_template () {
    '#!/usr/local/bin/perl
use Poet::Script qw($conf $env);
use strict;
use warnings;

';
}

1;

__END__
=pod

=head1 SEE ALSO

L<Poet|Poet>

=head1 AUTHOR

Jonathan Swartz <swartz@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Jonathan Swartz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

