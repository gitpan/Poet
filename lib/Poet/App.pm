package Poet::App;
$Poet::App::VERSION = '0.14';
use Moose;

extends qw(MooseX::App::Cmd);

__PACKAGE__->meta->make_immutable();

1;
