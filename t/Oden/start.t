use strict;
use warnings;
use utf8;
use Test::Exception;
use Test::Spec;
use Oden;

describe 'about Oden#start' => sub {
    my $hash;
    share %$hash;

    context 'when call start method' => sub {
        before all => sub {
            $hash->{oden} = Oden->new(token => 'your token');

            my $stubs = Oden::Bot::Discord->stubs(
                run => sub { 'called Oden::Bot::Discord#run' },
            );
        };

        it 'should execute Oden::Bot::Discord#run' => sub {
            my $oden = $hash->{oden};
            isa_ok    $oden,          'Oden',                          'instance is Oden';
            is        $oden->{token}, 'your token',                    'token is your token';
            is        $oden->start(), 'called Oden::Bot::Discord#run', 'called Oden::Bot::Discord#run';
        };

    };
};

runtests;
