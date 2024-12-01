use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::Logger;

describe 'about Oden#logger' => sub {
    my $hash;

    describe 'when call method' => sub {
        before_all "setup" => sub {
            $hash->{logger} = Oden::Logger->new;
        };
        it 'should return Oden::Logger instance' => sub {
            my $logger = $hash->{logger};
            isa_ok    $logger,          ['Oden::Logger'],           'instance is Oden::Logger';
            is        refaddr($logger), refaddr(Oden::Logger->new), 'Oden::Logger is singleton';
        };
    };
};

done_testing();
