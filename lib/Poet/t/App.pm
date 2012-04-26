package Poet::t::App;
BEGIN {
  $Poet::t::App::VERSION = '0.03';
}
use Poet::Test::Util;
use Test::Most;
use strict;
use warnings;
use base qw(Test::Class);

sub test_app_name_to_dir : Tests {
    require Poet::App::Command::new;

    my $try = sub {
        return Poet::App::Command::new->app_name_to_dir( $_[0] );
    };
    is( $try->("FooBar"),  "foo_bar" );
    is( $try->("HM"),      "hm" );
    is( $try->("foo_bar"), "foo_bar" );
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

