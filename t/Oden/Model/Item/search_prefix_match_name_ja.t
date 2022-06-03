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
                アラグの樹脂
                アラグの上級硬化薬
                アラグの時砂
                アラグ金貨
                アラグの硬化薬
                アラグ錫貨
                アラグの上級魔触媒
                アラグの強化繊維
                アラグ銀貨
                アラグ白金貨
                アラグの絶霊油
                アラグの魔触媒
                アラグ銅貨
                アラグの時油
            /)];
            is_deeply $res, $expect;
        };
    };

};

runtests unless caller;
