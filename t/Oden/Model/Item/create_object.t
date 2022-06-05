use strict;
use warnings;
use utf8;

use Test::Spec;

use Oden::Model::Item;

describe 'about Oden::Model::Item#new' => sub {
    my $hash;
    share %$hash;

    context 'case call new method' => sub {
        it 'when returns object' => sub {
            my $item = Oden::Model::Item->new();
            isa_ok $item, 'Oden::Model::Item';
        };
    };
};

describe 'about Oden::Model::Item#lookup_item_by_name' => sub {
    my $hash;
    share %$hash;

    context 'case call lookup_item_by_name_ja method with out name_ja arguments' => sub {
        it 'when returns undef' => sub {
            my $item = Oden::Model::Item->lookup_item_by_name();
            is $item, undef;
        };
    };

    context 'case call lookup_item_by_name_ja method with official name(ja)' => sub {
        it 'when returns item object' => sub {
            my $item = Oden::Model::Item->lookup_item_by_name('アラグ錫貨');
            isa_ok $item, 'Oden::Model::Item';
        };
    };

    context 'case call lookup_item_by_name_ja method with official name(ja)' => sub {
        it 'when returns item object' => sub {
            my $item = Oden::Model::Item->lookup_item_by_name('アラグ錫貨');
            isa_ok $item, 'Oden::Model::Item';
        };
    };

    context 'case call lookup_item_by_name_ja metod via new method' => sub {
        it 'when returns item object' => sub {
            my $instance    = Oden::Model::Item->new;
            my $item_object = $instance->lookup_item_by_name('アラグ錫貨');
            isa_ok $item_object, 'Oden::Model::Item';
        };
    };

    context 'case call lookup_item_by_name_ja method with official name(en)' => sub {
        it 'when returns item object' => sub {
            my $item = Oden::Model::Item->lookup_item_by_name('Allagan Tin Piece');
            isa_ok $item, 'Oden::Model::Item';
        };
    };

    context 'case call lookup_item_by_name_ja method with official name(de)' => sub {
        it 'when returns item object' => sub {
            my $item = Oden::Model::Item->lookup_item_by_name('Allagisches Zinnstück');
            isa_ok $item, 'Oden::Model::Item';
        };
    };

    context 'case call lookup_item_by_name_ja method with official name(fr)' => sub {
        it 'when returns item object' => sub {
            my $item = Oden::Model::Item->lookup_item_by_name(q{Pièce d'étain allagoise});
            isa_ok $item, 'Oden::Model::Item';
        };
    };

};

# XXX: forkprove has caller
# runtests unless caller;
runtests();
