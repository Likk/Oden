# discrod bot Core.
requires 'AnyEvent::Discord';
requires 'Config::Pit';

# chat operations.
requires 'JSON::XS';
requires 'URI::Escape';

## AnyEvent::Discord dependencys
requires 'LWP::Protocol::https';
requires 'Net::SSLeay';

on 'develop' => sub {
    requires 'Data::Dumper';
    requires 'YAML';
};

on 'test' => sub {
    requires 'Test::More';
    requires 'Test::Perl::Critic';
    requires 'Test::Pod';
    requires 'Test::Spelling';
};
