package Poet::t::Log;
BEGIN {
  $Poet::t::Log::VERSION = '0.05';
}
use JSON::XS;
use Test::Class::Most parent => 'Poet::Test::Class';

__PACKAGE__->initialize_temp_env();

sub test_log_config : Tests {
    my $env      = Poet::Environment->current_env;
    my $conf     = $env->conf;
    my $logs_dir = $env->logs_dir;

    my $test = sub {
        my ( $conf_settings, $expected ) = @_;
        my $lex      = $conf->set_local($conf_settings);
        my $log_conf = Poet::Log->generate_log4perl_config();
        is( $log_conf, $expected, encode_json($conf_settings) );
    };

    my $default_layout =
      "%d{dd/MMM/yyyy:HH:mm:ss.SS} [%p] %c - %m - %F:%L - %P%n";

    $test->(
        {},
        "log4perl.logger = INFO, default
log4perl.appender.default = Log::Log4perl::Appender::File
log4perl.appender.default.layout = Log::Log4perl::Layout::PatternLayout
log4perl.appender.default.layout.ConversionPattern = $default_layout
log4perl.appender.default.filename = $logs_dir/poet.log
"
    );

    $test->(
        { log => { 'defaults' => { level => 'debug', output => 'foo.log' } } },
        "log4perl.logger = DEBUG, default
log4perl.appender.default = Log::Log4perl::Appender::File
log4perl.appender.default.layout = Log::Log4perl::Layout::PatternLayout
log4perl.appender.default.layout.ConversionPattern = $default_layout
log4perl.appender.default.filename = $logs_dir/foo.log
"
    );

    $test->(
        {
            log => {
                'defaults' => { level => 'info', output => 'foo.log' },
                'class'    => {
                    'Bar' => { level => 'warn', output => 'bar.log' },
                    'Bar.Errors'    => { output => 'stderr' },
                    'Bar.NonErrors' => { output => 'stdout' },
                }
            }
        },
        "log4perl.logger = INFO, default
log4perl.appender.default = Log::Log4perl::Appender::File
log4perl.appender.default.layout = Log::Log4perl::Layout::PatternLayout
log4perl.appender.default.layout.ConversionPattern = $default_layout
log4perl.appender.default.filename = $logs_dir/foo.log

log4perl.logger.Bar = WARN, Bar
log4perl.appender.Bar = Log::Log4perl::Appender::File
log4perl.appender.Bar.layout = Log::Log4perl::Layout::PatternLayout
log4perl.appender.Bar.layout.ConversionPattern = $default_layout
log4perl.appender.Bar.filename = $logs_dir/bar.log

log4perl.logger.Bar.Errors = INFO, Bar_Errors
log4perl.appender.Bar_Errors = Log::Log4perl::Appender::Screen
log4perl.appender.Bar_Errors.layout = Log::Log4perl::Layout::PatternLayout
log4perl.appender.Bar_Errors.layout.ConversionPattern = $default_layout

log4perl.logger.Bar.NonErrors = INFO, Bar_NonErrors
log4perl.appender.Bar_NonErrors = Log::Log4perl::Appender::Screen
log4perl.appender.Bar_NonErrors.layout = Log::Log4perl::Layout::PatternLayout
log4perl.appender.Bar_NonErrors.layout.ConversionPattern = $default_layout
log4perl.appender.Bar_NonErrors.stderr = 0
"
    );
}

1;
