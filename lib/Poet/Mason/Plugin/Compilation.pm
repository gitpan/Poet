package Poet::Mason::Plugin::Compilation;
BEGIN {
  $Poet::Mason::Plugin::Compilation::VERSION = '0.03';
}
use Mason::PluginRole;

# Add 'use Poet qw($conf $env :web)' at the top of every component
#
override 'output_class_header' => sub {
    return join( "\n", super(), 'use Poet qw($conf $env :web);' );
};

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

