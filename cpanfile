# discrod bot Core.
requires 'AnyEvent::Discord';
requires 'Config::Pit';

# chat operations.
requires 'Furl';
requires 'JSON::XS';
requires 'Number::Format';
requires 'Text::CSV';
requires 'Text::CSV_XS';
requires 'Time::Piece';
requires 'URI::Escape';
requires 'Games::Dice';

## util
requires 'Array::Diff';
requires 'File::RotateLogs';
requires 'Log::Minimal';


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
    requires 'Test::More';
    requires 'Test::Spec';

    # ./xt layer
    requires 'Test::Perl::Critic';
    requires 'Test::Pod';
    requires 'Test::Spelling';
};
