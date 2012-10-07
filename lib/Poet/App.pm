package Poet::App;
BEGIN {
  $Poet::App::VERSION = '0.13';
}
use Moose;

extends qw(MooseX::App::Cmd);

__PACKAGE__->meta->make_immutable();

1;
