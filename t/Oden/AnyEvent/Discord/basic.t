use strict;
use warnings;
use utf8;
use Test::Exception;
use Test::Spec;
use Oden::AnyEvent::Discord;

describe 'about Oden::AnyEvent::Discord' => sub {
    my $hash;
    share %$hash;

    context 'when using Oden::AnyEvent::Discord' => sub {
        before all => sub {
            $hash->{discord} = AnyEvent::Discord->new;

            $hash->{stubs}   = AnyEvent::Discord->stubs(
                token            => sub { return 'your token'; },
                user_agent       => sub { return 'Perl-AnyEventDiscord/' . shift->VERSION },
                _ws_send_payload => sub { return $_[1]; },
                _debug           => sub {  },
                _discord_api     => sub { +{ url => "wss://gateway.discord.gg/" } },
            );
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
            is $gateway, 'wss://gateway.discord.gg/?v=9&encoding=json'
        };
    };
};

runtests;
