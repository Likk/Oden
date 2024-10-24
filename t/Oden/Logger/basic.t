use strict;
use warnings;
use utf8;
use Test::Exception;
use Test::Spec;
use Oden::Logger;

describe 'about Oden#logger' => sub {
    my $hash;
    share %$hash;

    context 'when call method' => sub {
        before all => sub {
            $hash->{logger} = Oden::Logger->new;
        };
        it 'should return Oden::Logger instance' => sub {
            my $logger = $hash->{logger};
            isa_ok    $logger, 'Oden::Logger',     'instance is Oden::Logger';
            is_deeply $logger, Oden::Logger->new,  'Oden::Logger is singleton';
        };
    };
};

runtests;
