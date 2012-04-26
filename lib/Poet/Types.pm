package Poet::Types;
BEGIN {
  $Poet::Types::VERSION = '0.03';
}
use Moose::Util::TypeConstraints;
use strict;
use warnings;

subtype
  'Poet::Types::AppName' => as 'Str',
  where { /^[[:alpha:]_]\w*$/ },
  message { "The app name you provided, '$_', was not a valid identifier" };

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

