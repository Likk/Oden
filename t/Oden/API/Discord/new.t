use strict;
use warnings;
use utf8;

use Test::Spec;
use Test::Exception;

use Oden::API::Discord;

describe 'about Oden::API::Discord#new' => sub {
    my $hash;
    share %$hash;

    context "Negative testing" => sub {
        context "token parameter is not set" => sub {
            it 'throw exception' => sub {
                throws_ok {
                    Oden::API::Discord->new()
                } qr/require token parameter/;
            };
        };
    };

    context "Positive testing" => sub {
        context "token parameter is set" => sub {
            before all => sub {
                $hash->{api} = Oden::API::Discord->new(token => 'dummy');
            };
            it 'return Oden::API::Discord object' => sub {
                my $api = $hash->{api};
                isa_ok $api, 'Oden::API::Discord';
            };
            it 'object has default hash' => sub {
                my $api = $hash->{api};
                is   $api->{base_url}, 'https://discordapp.com/api';
                like $api->{last_req}, qr/\d+/;
                is   $api->{interval}, 1;
            };
        };
    };
};

runtests();
