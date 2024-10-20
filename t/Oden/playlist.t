use strict;
use warnings;
use utf8;
use Test::Exception;
use Test::Spec;
use Oden;

describe 'about Oden#playlist' => sub {
    my $hash;
    share %$hash;

    context 'when call method' => sub {
        before all => sub {
            $hash->{oden} = Oden->new;
        };
        it 'should return Oden::playlist instance' => sub {
            my $oden = $hash->{oden};
            my $playlist = $oden->playlist;
            isa_ok    $playlist, 'Oden::Util::PlayList', 'instance is Oden::Util::PlayList';
            is_deeply $playlist, $oden->playlist,        'same instance';
        };

        it 'pick up a song' => sub {
            my $oden = $hash->{oden};
            my $playlist = $oden->playlist;
            ok $playlist->pick;
        };
    };
};

runtests;
