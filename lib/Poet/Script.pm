package Poet::Script;
BEGIN {
  $Poet::Script::VERSION = '0.03';
}
use Cwd qw(realpath);
use File::Basename;
use File::Spec::Functions qw(rel2abs);
use Method::Signatures::Simple;
use Poet::Environment;
use Poet::Util qw(can_load read_file);
use strict;
use warnings;

method import ($pkg:) {
    unless ( Poet::Environment->current_env ) {
        my $root_dir = determine_root_dir();
        my $env      = initialize_with_root_dir($root_dir);
    }
    Poet::Environment->current_env->importer->export_to_level( 1, @_ );
}

func initialize_with_root_dir($root_dir) {
    my $lib_dir = "$root_dir/lib";
      unless ( $INC[0] eq $lib_dir ) {
        unshift( @INC, $lib_dir );
    }

    my ($app_name) = ( read_file("$root_dir/.poet_root") =~ /app_name: (.*)/ )
      or die "cannot find app_name in $root_dir/.poet_root";

      return Poet::Environment->initialize_current_environment(
        root_dir => $root_dir,
        app_name => $app_name
      );
  }

  func determine_root_dir() {

    # Search for .poet_root upwards from current directory, using rel2abs
    # first, then realpath.
    #
    my $path1      = dirname( rel2abs($0) );
      my $path2    = dirname( realpath($0) );
      my $root_dir = search_upward($path1) || search_upward($path2);
      unless ( defined $root_dir ) {
        die sprintf( "could not find .poet_root upwards from %s",
            ( $path1 eq $path2 ) ? "'$path1'" : "'$path1' or '$path2'" );
    }
    return $root_dir;
  }

  func search_upward($path) {
    my $count = 0;
      while ( realpath($path) ne '/' && $count++ < 10 ) {
        if ( -f "$path/.poet_root" ) {
            return realpath($path);
            last;
        }
        $path = dirname($path);
    }
    return undef;
  }

  1;


__END__
=pod

=head1 NAME

Poet::Script -- Intialize Poet for a script

=head1 SYNOPSIS

    # In a script...
    use Poet::Script qw($cache $conf $env $log :file);

=head1 DESCRIPTION

This module is used to initialize Poet for a script. It does the following:

=over

=item *

Determines the environment root by looking upwards from the directory of the
current script until it finds the Poet marker file (C<.poet_root>).

=item *

Reads and parses configuration files.

=item *

Shifts the C<lib/> subdirectory of the environment root onto C<@INC>.

=item *

Imports the specified I<quick vars> and utility sets into the current package -
see L<Poet::Import|Poet::Import>.

=back

=head1 SEE ALSO

L<Poet|Poet>

=head1 AUTHOR

Jonathan Swartz <swartz@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Jonathan Swartz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

