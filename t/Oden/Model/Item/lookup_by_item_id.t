use strict;
use warnings;
use utf8;

use Test::Spec;

# import でファイル読み込みを行うので、テストでは直前まで読み込まないようにする
use Oden::Model::Item();

describe 'about Oden::Model::Item#lookup_item_by_id' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        local $ENV{DATA_DIR} = './t/Oden/Model/Item/data';
        Oden::Model::Item->import;
    };
    context 'case call lookup_item_by_id method with numeric' => sub {
        it 'when returns undef' => sub {
            for my $item_id (qw/10 11 12 13 14/){
                my $item    = Oden::Model::Item->lookup_item_by_id($item_id);
                is $item->{'#'}, $item_id;
            }
        };
    };
};

runtests();
