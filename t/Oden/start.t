use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden;

describe 'about Oden#start' => sub {
    my $hash;

    describe 'when call start method' => sub {
        before_all "setup" => sub {
            $hash->{oden} = Oden->new(token => 'your token');

            $hash->{mocks} = mock "Dashi::Bot::Discord" => (
                override => [
                    run => sub { 'called Dashi::Bot::Discord#run' },
                ],
            );
        };

        it 'should execute Oden::Bot::Discord#run' => sub {
            my $oden = $hash->{oden};
            isa_ok    $oden,          ['Oden'],                        'instance is Oden';
            is        $oden->{token}, 'your token',                    'token is your token';
            is        $oden->start(), 'called Dashi::Bot::Discord#run', 'called Dashi::Bot::Discord#run';
        };

    };
};

done_testing();
