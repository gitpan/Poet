# Test Log::Log4perl not being present.
#
package Poet::t::NoLog4perl;
BEGIN {
  $Poet::t::NoLog4perl::VERSION = '0.07';
}
use Test::Class::Most parent => 'Poet::Test::Class';
use Module::Mask;
use Poet::Tools qw(read_file);
use strict;
use warnings;

sub test_main : Tests {
    my $self       = shift;
    my $mask       = new Module::Mask('Log::Log4perl');
    my $env        = $self->initialize_temp_env();
    my $error_file = $env->logs_path("poet.log.ERROR");
    ok( -f $error_file, "$error_file exists" );
    like( read_file($error_file), qr/Could not load Log::Log4perl/ );
}

1;
