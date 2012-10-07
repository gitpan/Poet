package Poet::Mason::Plugin;
BEGIN {
  $Poet::Mason::Plugin::VERSION = '0.13';
}
use Moose;
with 'Mason::Plugin';

__PACKAGE__->meta->make_immutable();

1;
