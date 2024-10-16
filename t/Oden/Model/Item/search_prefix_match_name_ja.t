use strict;
use warnings;
use utf8;

use Test::Spec;
use Oden::Model::Item;

describe 'about Oden::Model::Item#search_prefix_match_name_ja' => sub {
    my $hash;
    share %$hash;

    context 'case call search_prefix_match_name_ja methods without arguments' => sub {
        it 'when returns undef' => sub {
            my $res = Oden::Model::Item->new->search_prefix_match_name;
            is $res, undef;
        };
    };

    context 'case call search_prefix_match_name_ja methods with name (ja)' => sub {
        it 'when returns official item name list' => sub {
            my $res    = [sort(@{ Oden::Model::Item->new->search_prefix_match_name('アラグ') })];
            my $expect = [sort(qw/
                アラグ金貨
                アラグ錫貨
                アラグ銀貨
                アラグ白金貨
                アラグ銅貨
            /)];
            is_deeply $res, $expect;
        };
    };

};

runtests();
