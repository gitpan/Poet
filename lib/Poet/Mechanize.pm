package Poet::Mechanize;
BEGIN {
  $Poet::Mechanize::VERSION = '0.11';
}
use Poet::Environment;
use Plack::Util;
use base qw(Test::WWW::Mechanize::PSGI);

sub new {
    my ( $class, %params ) = @_;
    my $poet = delete( $params{'env'} ) || Poet::Environment->current_env;
    my $app = Plack::Util::load_psgi( $poet->bin_path("app.psgi") );
    return $class->SUPER::new( app => $app, %params );
}

1;
