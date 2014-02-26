package Poet::App;
$Poet::App::VERSION = '0.15';
use Moose;

extends qw(MooseX::App::Cmd);

__PACKAGE__->meta->make_immutable();

1;
