package Poet::Mason::Plugin::Compilation;
BEGIN {
  $Poet::Mason::Plugin::Compilation::VERSION = '0.12';
}
use Mason::PluginRole;

# Add 'use Poet qw($conf $poet :web)' at the top of every component
#
override 'output_class_header' => sub {
    return join( "\n", super(), 'use Poet qw($conf $poet :web);' );
};

1;
