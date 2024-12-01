use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::API::Discord;

describe 'about Oden::API::Discord#new' => sub {
    my $hash;

    describe "Negative testing" => sub {
        describe "token parameter is not set" => sub {
            it 'throw exception' => sub {
                my $throws = dies {
                    Oden::API::Discord->new()
                };
                like $throws, qr/require token parameter/;
            };
        };
    };

    describe "Positive testing" => sub {
        describe "token parameter is set" => sub {
            before_all "create Oden::API::Discord object"  => sub {
                $hash->{api} = Oden::API::Discord->new(token => 'dummy');
            };
            it 'return Oden::API::Discord object' => sub {
                my $api = $hash->{api};
                isa_ok $api, ['Oden::API::Discord'];
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

done_testing();
