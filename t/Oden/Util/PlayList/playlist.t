use strict;
use warnings;
use utf8;
use Test::Exception;
use Test::Spec;
use Oden::Util::PlayList;

describe 'about Oden::Util::PlayList' => sub {
    my $hash;
    share %$hash;

    context 'when call method' => sub {
        before all => sub {
            $hash->{playlist} = Oden::Util::PlayList->new;
        };
        it 'should return Oden::Util::PlayList instance' => sub {
            my $playlist = $hash->{playlist};
            isa_ok    $playlist, 'Oden::Util::PlayList', 'instance is Oden::Util::PlayList';
        };

        it 'pick up a song' => sub {
            my $playlist = $hash->{playlist};
            ok $playlist->pick;
        };
    };
};

runtests;
