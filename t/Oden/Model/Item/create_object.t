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

describe 'about Oden::Model::Item#lookup_item_by_name_ja' => sub {
    my $hash;
    share %$hash;

    context 'case call lookup_item_by_name_ja method with out name_ja arguments' => sub {
        it 'when returns undef' => sub {
            my $item = Oden::Model::Item->lookup_item_by_name_ja();
            is $item, undef;
        };
    };

    context 'case call lookup_item_by_name_ja method with official name_ja' => sub {
        it 'when returns item object' => sub {
            my $item = Oden::Model::Item->lookup_item_by_name_ja('アラグ錫貨');
            isa_ok $item, 'Oden::Model::Item';
        };
    };

    context 'case call lookup_item_by_name_ja metod via new method' => sub {
        it 'when returns item object' => sub {
            my $instance    = Oden::Model::Item->new;
            my $item_object = $instance->lookup_item_by_name_ja('アラグ錫貨');
            isa_ok $item, 'Oden::Model::Item';
        };
    };
};

runtests unless caller;
