use strict;
use warnings;
use utf8;

use Test::Spec;

use Oden::API::Universalis;

describe 'about Oden::API::Universalis#current_data' => sub {
    my $hash;
    share %$hash;

    context 'case call current_data method' => sub {
        it 'when returns sales data' => sub {
            my $res = Oden::API::Universalis->current_data(+{
                item_ids    => [36213],
                world_or_dc => 'zeromus',
            });
            ok $res;
        };
    };
};

# XXX: forkprove has caller
# runtests unless caller;
runtests();
