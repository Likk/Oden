use strict;
use warnings;
use utf8;
use Test::Warn;
use Test::Spec;
use Oden::Logger;

describe 'about Oden::Logger#warnf' => sub {
    my $hash;
    share %$hash;

    context 'when call method' => sub {
        before all => sub {
            $hash->{stubs}  = File::RotateLogs->stubs(
                print => sub { $hash->{log} = $_[1]; }
            );
        };
        it 'should return Oden::Logger instance' => sub {
            warning_like {
                Oden::Logger->new->warnf('warn message');
            } qr/warn message at .* line \d+/;
            my $log    = $hash->{log};
            like $log, qr/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2} \[WARN\] warn message at .* line \d+\s\z/;
        };
    };
};

runtests;
