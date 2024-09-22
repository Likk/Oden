use strict;
use warnings;
use utf8;

use Test::Spec;
use Oden::Model::Item;

describe 'about Oden::Model::Item#lookup_item_by_id' => sub {
    my $hash;
    share %$hash;

    context 'case call lookup_item_by_id method with numeric' => sub {
        it 'when returns undef' => sub {
            for (1..3){
                my $id = int(rand(38000) ) + 1;
                my $item = Oden::Model::Item->lookup_item_by_id($id);
                is $item->{'#'}, $id;
            }
        };
    };
};

runtests();
