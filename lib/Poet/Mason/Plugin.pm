package Poet::Mason::Plugin;
$Poet::Mason::Plugin::VERSION = '0.15';
use Moose;
with 'Mason::Plugin';

__PACKAGE__->meta->make_immutable();

1;
