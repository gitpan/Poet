package Poet::Types;
BEGIN {
  $Poet::Types::VERSION = '0.11';
}
use Moose::Util::TypeConstraints;
use strict;
use warnings;

subtype
  'Poet::Types::AppName' => as 'Str',
  where { /^[[:alpha:]_]\w*$/ },
  message { "The app name you provided, '$_', was not a valid identifier" };

1;
