use strict;
use warnings;
use utf8;

use Test::Spec;
use Test::Exception;

use Oden::API::Discord;

describe 'about Oden::API::Discord#endpoint_config' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{discord} = Oden::API::Discord->new(token => 'dummy');
    };

    context "call endpoint_config method" => sub {
        it 'will return endpoint list' => sub {
            my $discord   = $hash->{discord};
            my $endpoints = $discord->endpoint_config();

            isa_ok $endpoints, 'HASH';
            is_deeply $endpoints, +{
                show_message       => 'https://discordapp.com/api/channels/%s/messages/%s',
                show_channel       => 'https://discordapp.com/api/channels/%s',
                show_user          => 'https://discordapp.com/api/users/%s',
                list_guild_members => 'https://discordapp.com/api/guilds/%s/members',
            }, 'return endpoint list';
        };
    };
};

runtests();
