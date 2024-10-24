use strict;
use warnings;
use utf8;
use Test::Exception;
use Test::Spec;
use Oden::Logger;

describe 'about Oden::Logger#say' => sub {
    my $hash;
    share %$hash;

    context 'when call method' => sub {
        before all => sub {
            $hash->{stubs}  = File::RotateLogs->stubs(
                print => sub { $hash->{log} = $_[1]; }
            );

            Oden::Logger->new->say('say message');
        };
        it 'should logging message' => sub {
            my $log = $hash->{log};
            like $log, qr/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2} \[SAY\] say message/;
        };
    };
};

runtests;
