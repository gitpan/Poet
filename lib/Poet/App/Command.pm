package Poet::App::Command;
BEGIN {
  $Poet::App::Command::VERSION = '0.03';
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

