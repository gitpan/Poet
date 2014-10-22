package Poet::Environment;
BEGIN {
  $Poet::Environment::VERSION = '0.13';
}
use Carp;
use File::Slurp;
use Poet::Moose;
use Poet::Tools qw(can_load catdir);

has 'app_name'    => ( required => 1 );
has 'conf'        => ();
has 'importer'    => ();
has 'log_manager' => ();
has 'root_dir'    => ( required => 1 );

my ($current_env);

method subdirs () { [qw(bin comps conf data db lib logs static t)] }

method app_class ($class_name) {
    my $app_class_name = join( "::", $self->app_name, $class_name );
    my $env_class_name = join( "::", "Poet",          $class_name );
    return
        can_load($app_class_name) ? $app_class_name
      : can_load($env_class_name) ? $env_class_name
      :                             die "cannot load $app_class_name or $class_name";
}

method generate_subdir_methods ($class:) {
    foreach my $subdir ( 'root', @{ $class->subdirs() } ) {
        my $dir_method = $subdir . "_dir";
        has $dir_method => () if $subdir ne 'root';
        my $path_method = $subdir eq 'root' ? "path" : $subdir . "_path";
        __PACKAGE__->meta->add_method(
            $path_method,
            sub {
                my ( $self, $relpath ) = @_;
                croak "$path_method expects relative path as argument"
                  unless defined($relpath);
                return $self->$dir_method . "/" . $relpath;
            }
        );
    }
}

method initialize_current_environment ($class: %params) {
    if ( defined($current_env) ) {
        die sprintf( "initialize_current_environment called when current_env already set (%s)",
            $current_env->root_dir() );
    }
    $current_env = $params{env} || $class->new(%params);

    # Initialize logging and caching
    #
    $current_env->app_class('Log')->initialize_logging();
    $current_env->app_class('Cache')->initialize_caching();

    return $current_env;
}

method current_env ($class:) {
    return $current_env;
}

method BUILD () {
    my $root_dir = $self->root_dir();

    # Unshift lib dir onto @INC
    #
    my $lib_dir = "$root_dir/lib";
    unless ( $INC[0] eq $lib_dir ) {
        unshift( @INC, $lib_dir );
    }

    # Initialize configuration
    #
    $self->{conf} =
      $self->app_class('Conf')
      ->new( root_dir => $root_dir, conf_dir => catdir( $root_dir, "conf" ) );
    my $conf = $self->{conf};

    # Initialize importer
    #
    $self->{importer} = $self->app_class('Import')->new( env => $self );

    # Determine where our standard subdirectories (bin, comps, etc.)
    # are. Can override in configuration with env.bin_dir, env.comps_dir,
    # etc.  Otherwise use obvious defaults.
    #
    foreach my $subdir ( @{ $self->subdirs() } ) {
        my $method = $subdir . "_dir";
        $self->{$method} = $conf->get( "env.$method" => "$root_dir/$subdir" );
    }
}

__PACKAGE__->generate_subdir_methods();
__PACKAGE__->meta->make_immutable();

1;



=pod

=head1 NAME

Poet::Environment -- Poet environment

=head1 SYNOPSIS

    # In a script...
    use Poet::Script qw($poet);

    # In a module...
    use Poet qw($poet);

    # $poet is automatically available in Mason components

    # then...
    my $root_dir       = $poet->root_dir;
    my $file           = $poet->path("some/file.txt");
    my $path_to_script = $poet->bin_path("foo/bar.pl");
    my $path_to_lib    = $poet->lib_path("Foo/Bar.pm");

=head1 DESCRIPTION

The Poet::Environment object contains information about the current environment
and its directory paths.

=head1 PATH METHODS

=over

=item root_dir

Returns the root directory of the environment, i.e. where I<.poet_root> is
located.

=item path (subpath)

Returns the root directory with a relative I<subpath> added. e.g. if the Poet
environment root is C</my/env/root>, then

    $poet->path("somefile.txt");
       ==> returns /my/env/root/somefile.txt

=item bin_dir

=item comps_dir

=item conf_dir

=item data_dir

=item db_dir

=item lib_dir

=item logs_dir

=item static_dir

Returns the specified subdirectory, which by default will be just below the
root dirctory. e.g. if the Poet environment root is C</my/env/root>, then

    $poet->conf_dir
       ==> returns /my/env/root/conf

    $poet->lib_dir
       ==> returns /my/env/root/lib

=item bin_path (subpath)

=item comps_path (subpath)

=item conf_path (subpath)

=item data_path (subpath)

=item db_path (subpath)

=item lib_path (subpath)

=item logs_path (subpath)

=item static_path (subpath)

Returns the specified subdirectory with a relative I<subpath> added. e.g. if
the Poet environment root is C</my/env/root>, then

    $poet->conf_path("log4perl.conf");
       ==> returns /my/env/root/conf/log4perl.conf

    $poet->lib_path("Data/Type.pm");
       ==> returns /my/env/root/lib/Data/Type.pm

=back

=head1 OTHER METHODS

=over

=item app_class

Returns the full class name to use for the specified class, depending on
whether there is a subclass in the environment. e.g.

    $poet->app_class('Cache')

will return C<MyApp::Cache> if that module exists, and otherwise
C<Poet::Cache>.  This is used internally by Poet to implement L<auto
subclassing|Poet::Manual::Subclassing>.

=item app_name

Returns the app name, e.g. 'MyApp', found in .poet_root.

=item conf

Returns the L<Poet::Conf|Poet::Conf> object associated with the environment.
Usually you'd access this by importing C<$conf>.

=item current_env

A class method that returns the current (singleton) environment for the
process. Usually you'd access this by importing C<$poet>.

=back

=head1 OBTAINING $poet SINGLETON

In a script:

    use Poet::Script qw($poet);

In a module:

    use Poet qw($poet);

C<$poet> is automatically available in components.

You can also get it via

    my $poet = Poet::Environment->current_env;

=head1 CONFIGURING ENVIRONMENT SUBDIRECTORIES

Any subdirectories other than conf_dir can be overridden in configuration. e.g.

    # Override bin_dir
    env.bin_dir: /some/other/bin/dir

With this configuration in place,

    $poet->bin_dir
       ==> returns /some/other/bin/dir

    $poet->bin_path("foo/bar.pl")
       ==> returns /some/other/bin/dir/foo/bar.pl

=head1 SEE ALSO

L<Poet|Poet>

=head1 AUTHOR

Jonathan Swartz <swartz@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Jonathan Swartz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

