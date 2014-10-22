package Poet::t::Import;
BEGIN {
  $Poet::t::Import::VERSION = '0.02';
}
use Poet::Test::Util;
use Test::Most;
use strict;
use warnings;
use base qw(Test::Class);

my ( $temp_env, $importer );

BEGIN {
    $temp_env = initialize_temp_env();
    $importer = $temp_env->importer;
}

sub test_valid_vars : Tests {
    cmp_deeply( $importer->valid_vars, supersetof(qw(cache conf env log)) );
}

sub test_import_vars : Tests {
    {
        package TestImportVars;
BEGIN {
  $TestImportVars::VERSION = '0.02';
}
        BEGIN { $importer->export_to_level( 0, qw($cache $conf $env) ) }
        use Test::Most;
        isa_ok( $cache, 'CHI::Driver',       '$cache' );
        isa_ok( $conf,  'Poet::Conf',        '$conf' );
        isa_ok( $env,   'Poet::Environment', '$env' );
    }
}

sub test_import_methods : Tests {
    {
        package TestImportMethods1;
BEGIN {
  $TestImportMethods1::VERSION = '0.02';
}
        BEGIN { $importer->export_to_level(0) }
        use Test::Most;
        ok( TestImportMethods1->can('dp'),        'yes dp' );
        ok( !TestImportMethods1->can('basename'), 'no basename' );
    }
    {
        package TestImportMethods2;
BEGIN {
  $TestImportMethods2::VERSION = '0.02';
}
        BEGIN { $importer->export_to_level( 0, qw(:file) ) }
        use Test::Most;
        foreach my $function (qw(dp basename)) {
            ok( TestImportMethods2->can($function), "yes $function" );
        }
    }
    {
        package TestImportMethods3;
BEGIN {
  $TestImportMethods3::VERSION = '0.02';
}
        BEGIN { $importer->export_to_level( 0, qw(:web) ) }
        use Test::Most;
        foreach my $function (qw(dp html_escape uri_escape)) {
            ok( TestImportMethods3->can($function), "yes $function" );
        }
    }
}

1;
