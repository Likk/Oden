use 5.40.0;
use Test2::Bundle::Extended;
use Test2::Tools::Spec;

use Oden::AnyEvent::Discord;

describe 'about Oden::AnyEvent::Discord' => sub {
    my $hash = {};

    describe 'when using Oden::AnyEvent::Discord' => sub {
        before_all setup => sub {

            $hash->{discord} = AnyEvent::Discord->new;
            my $mock = mock "AnyEvent::Discord" => (
                add => [
                    token            => sub { return 'your token'; },
                    user_agent       => sub { return 'Perl-AnyEventDiscord/' . shift->VERSION },
                    _ws_send_payload => sub { return $_[1]; },
                    _debug           => sub {  },
                    _discord_api     => sub { +{ url => "wss://gateway.discord.gg.example/" } }
                ],
            );
            $hash->{mock} = $mock;
        };

        it 'add update_status method at AnyEvent::Discord' => sub {
            my $payload = $hash->{discord}->update_status(+{});
            is   $payload->{op},          3;
            like $payload->{d}->{since},  qr/\d+/;
            is   $payload->{d}->{status}, 'online';
            is   $payload->{d}->{afk},    'false';
        };

        it 'patched _discord_identify method at AnyEvent::Discord' => sub {
            my $payload = $hash->{discord}->_discord_identify();
            is   $payload->{op},                         2;
            is   $payload->{d}->{token},                 'your token';
            is   $payload->{d}->{properties}->{os},      'linux';
            is   $payload->{d}->{properties}->{browser}, 'Perl-AnyEventDiscord/0.7';
            is   $payload->{d}->{properties}->{device},  'Perl-AnyEventDiscord/0.7';
            is   $payload->{d}->{intents},                2563; #'1<<0|1<<1|1<<9|1<<11' //TODO parameterize
        };

        it 'patched _lookup_gateway method at AnyEvent::Discord' => sub {
            my $gateway = $hash->{discord}->_lookup_gateway();
            is $gateway, 'wss://gateway.discord.gg.example/?v=9&encoding=json'
        };
    };
};

done_testing();
