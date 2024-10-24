use strict;
use warnings;
use utf8;
use Test::Exception;
use Test::Spec;
use Oden::Logger;

describe 'about Oden::Logger#critf' => sub {
    my $hash;
    share %$hash;

    context 'when call method' => sub {
        before all => sub {
            $hash->{stubs}  = File::RotateLogs->stubs(
                print => sub { $hash->{log} = $_[1]; }
            );
        };
        it 'should return Oden::Logger instance' => sub {
            throws_ok {
                Oden::Logger->new->critf('critical message');
            } qr/critical message at .* line \d+/;

            my $log    = $hash->{log};
            like $log, qr/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2} \[CRITICAL\] critical message at .* line \d+\s\z/;
        };
    };
};

runtests;
