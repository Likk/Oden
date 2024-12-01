use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::Model::Item;

describe 'about Oden::Model::Item#lookup_item_by_name' => sub {
    my $hash;

    describe 'case no parametor' => sub {
        it 'when throws exception' => sub {
            my $throw = dies {
                my $item = Oden::Model::Item->lookup_item_by_name();
            };
            like $throw, qr/Too few arguments for method lookup_item_by_name/;
        };
    };

    describe 'case parametor is empty string' => sub {
        it 'when returns undef' => sub {
            my $item = Oden::Model::Item->lookup_item_by_name('');
            is $item, undef;
        };
    };

    describe 'case parametor is string' => sub {
        describe 'case official name(ja)' => sub {
            it 'when returns item object' => sub {
                my $item = Oden::Model::Item->lookup_item_by_name('アラグ錫貨');
                isa_ok $item, ['Oden::Model::Item'];
            };
        };


        describe 'case official name(en)' => sub {
            it 'when returns item object' => sub {
                my $item = Oden::Model::Item->lookup_item_by_name('Allagan Tin Piece');
                isa_ok $item, ['Oden::Model::Item'];
            };
        };

        describe 'case official name(de)' => sub {
            it 'when returns item object' => sub {
                my $item = Oden::Model::Item->lookup_item_by_name('Allagisches Zinnstück');
                isa_ok $item, ['Oden::Model::Item'];
            };
        };

        describe 'case official name(fr)' => sub {
            it 'when returns item object' => sub {
                my $item = Oden::Model::Item->lookup_item_by_name(q{Pièce d'étain allagoise});
                isa_ok $item, ['Oden::Model::Item'];
            };
        };
    };
};

done_testing();
