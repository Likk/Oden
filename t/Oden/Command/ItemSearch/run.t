use strict;
use warnings;
use utf8;

use Test::Spec;

use Oden::Command::ItemSearch;

describe 'about Oden::Command::ItemSearch#run' => sub {
    my $hash;
    share %$hash;

    context 'case call run method without arguments' => sub {
        it 'when returns undef' => sub {
            my $res = Oden::Command::ItemSearch->run();
            is $res, undef;
        };
    };

    context 'case call run method with official name_ja' => sub {
        it 'when returns item object' => sub {
            my $res = Oden::Command::ItemSearch->run('アラグ錫貨');
            like $res, qr{^lodestone:\shttps://jp.finalfantasyxiv.com/lodestone/(.*)?/\nmiraprisnap:\shttps://mirapri.com/\?keyword=(.*)?$};
        };
    };

    context 'case call run method with un official name_ja' => sub {
        it 'when returns item object' => sub {
            my $res = Oden::Command::ItemSearch->run('錫貨');
            is $res, undef;
        };
    };

};

runtests unless caller;
