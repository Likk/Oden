use strict;
use warnings;
use utf8;
use Test::Exception;
use Test::Spec;
use Oden;

describe 'about Oden#logger' => sub {
    my $hash;
    share %$hash;

    context 'when call method' => sub {
        before all => sub {
            $hash->{oden} = Oden->new;
        };
        it 'should return Oden::Logger instance' => sub {
            my $oden = $hash->{oden};
            my $logger = $oden->logger;
            isa_ok    $logger, 'Oden::Logger', 'instance is Oden::Logger';
            is_deeply $logger, $oden->logger,  'same instance';
        };
    };
};

runtests;
