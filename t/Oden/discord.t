use strict;
use warnings;
use utf8;
use Test::Exception;
use Test::Spec;
use Oden;

describe 'about Oden#discord' => sub {
    my $hash;
    share %$hash;

    context 'Negative testing' => sub {
        context 'when token is not set' => sub {
            before all => sub {
                $hash->{oden} = Oden->new;
            };
            it 'should exception' => sub {
                throws_ok {
                    $hash->{oden}->discord
                } qr/require token parameter./;
            };
        };
    };

    context 'Positive testing' => sub {
        context 'when token is set' => sub {
            before all => sub {
                $hash->{oden} = Oden->new(token => 'xxx');
            };
            it 'should return Oden::Discord instance' => sub {
                my $oden = $hash->{oden};
                my $discord = $oden->discord;
                isa_ok    $discord, 'Oden::API::Discord', 'instance is Oden::API::Discord';
                is_deeply $discord, $oden->discord,       'same instance';
            };
        };
    };
};

runtests;
