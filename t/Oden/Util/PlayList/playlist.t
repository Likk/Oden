use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::Util::PlayList;

describe 'about Oden::Util::PlayList' => sub {
    my $hash;

    describe 'when call method' => sub {
        before_all "setup" => sub {
            $hash->{playlist} = Oden::Util::PlayList->new;
        };
        it 'should return Oden::Util::PlayList instance' => sub {
            my $playlist = $hash->{playlist};
            isa_ok    $playlist, ['Oden::Util::PlayList'], 'instance is Oden::Util::PlayList';
        };

        it 'pick up a song' => sub {
            my $playlist = $hash->{playlist};
            ok $playlist->pick;
        };
    };
};

done_testing();
