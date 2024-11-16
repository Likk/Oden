# discrod bot Core.
requires 'AnyEvent::Discord';
requires 'Config::Pit';

# chat operations.
requires 'Furl';
requires 'Games::Dice';
requires 'JSON::XS';
requires 'List::Util';
requires 'Number::Format';
requires 'String::Random';
requires 'Text::CSV';
requires 'Text::CSV_XS';
requires 'Time::Piece';
requires 'URI::Escape';

## util
requires 'Array::Diff';
requires 'Class::Singleton';
requires 'Hash::Diff';
requires 'File::RotateLogs';
requires 'Function::Parameters';
requires 'Function::Return';
requires 'Types::Standard';
requires 'HTTP::Date';
requires 'HTTP::Parser::XS';
requires 'Log::Minimal';
requires 'Web::Query';
requires 'WebService::Discord::Webhook';

## AnyEvent::Discord dependencys
requires 'LWP::Protocol::https';
requires 'Net::SSLeay';

on 'develop' => sub {
    requires 'Data::Dumper';
    requires 'YAML';
};

on 'test' => sub {
    requires 'App::ForkProve';
    # ./t layer
    requires 'Sub::Meta';
    requires 'Test::Exception';
    requires 'Test::Spec';
    requires 'Test::Warn';
    # ./xt layer
    requires 'Test::More';
    requires 'Test::Perl::Critic';
    requires 'Test::Pod';
    requires 'Test::Pod::Coverage';
    requires 'Test::Spelling';
};
