package Poet::Mason::Plugin::Compilation;
BEGIN {
  $Poet::Mason::Plugin::Compilation::VERSION = '0.10';
}
use Mason::PluginRole;

# Add 'use Poet qw($conf $env :web)' at the top of every component
#
override 'output_class_header' => sub {
    return join( "\n", super(), 'use Poet qw($conf $env :web);' );
};

1;
