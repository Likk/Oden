use 5.40.0;
use Test2::V0;
use Test2::Tools::ClassicCompare qw/is_deeply/;
use Test2::Tools::Spec;

use Oden::API::Discord;

describe 'about Oden::API::Discord#endpoint_config' => sub {
    my $hash;

    before_all "setup" => sub {
        $hash->{discord} = Oden::API::Discord->new(token => 'dummy');
    };

    describe "call endpoint_config method" => sub {
        it 'will return endpoint list' => sub {
            my $discord   = $hash->{discord};
            my $endpoints = $discord->endpoint_config();

            ref_ok $endpoints, 'HASH';
            is_deeply $endpoints, +{
                show_message       => 'https://discordapp.com/api/channels/%s/messages/%s',
                show_channel       => 'https://discordapp.com/api/channels/%s',
                show_user          => 'https://discordapp.com/api/users/%s',
                list_guild_members => 'https://discordapp.com/api/guilds/%s/members',
            }, 'return endpoint list';
        };
    };
};

done_testing();
