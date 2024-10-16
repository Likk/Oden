use strict;
use warnings;
use utf8;

use Test::Spec;

# import でファイル読み込みを行うので、テストでは直前まで読み込まないようにする
use Oden::Model::Item();

describe 'about Oden::Model::Item#lookup_item_by_name' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        local $ENV{DATA_DIR} = './t/Oden/Model/Item/data';
        Oden::Model::Item->import;
    };

    context 'case no parametor' => sub {
        it 'when returns undef' => sub {
            my $item = Oden::Model::Item->lookup_item_by_name();
            is $item, undef;
        };
    };

    context 'case parametor is empty string' => sub {
        it 'when returns undef' => sub {
            my $item = Oden::Model::Item->lookup_item_by_name('');
            is $item, undef;
        };
    };

    context 'case parametor is string' => sub {
        context 'case official name(ja)' => sub {
            it 'when returns item object' => sub {
                my $item = Oden::Model::Item->lookup_item_by_name('アラグ錫貨');
                isa_ok $item, 'Oden::Model::Item';
            };
        };


        context 'case official name(en)' => sub {
            it 'when returns item object' => sub {
                my $item = Oden::Model::Item->lookup_item_by_name('Allagan Tin Piece');
                isa_ok $item, 'Oden::Model::Item';
            };
        };

        context 'case official name(de)' => sub {
            it 'when returns item object' => sub {
                my $item = Oden::Model::Item->lookup_item_by_name('Allagisches Zinnstück');
                isa_ok $item, 'Oden::Model::Item';
            };
        };

        context 'case official name(fr)' => sub {
            it 'when returns item object' => sub {
                my $item = Oden::Model::Item->lookup_item_by_name(q{Pièce d'étain allagoise});
                isa_ok $item, 'Oden::Model::Item';
            };
        };
    };
};

runtests();
