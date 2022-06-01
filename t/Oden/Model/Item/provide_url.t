use strict;
use warnings;
use utf8;

use Test::Spec;

use Oden::Model::Item;

describe 'about Oden::Model::Item#(.+)_url' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{item} = Oden::Model::Item->lookup_item_by_name_ja('ララフェルカフタン');
    };

    context 'case call lodestone_url' => sub {
        it 'when returns offical lodestone url' => sub {
            my $url = $hash->{item}->lodestone_url;
            is $url, "https://jp.finalfantasyxiv.com/lodestone/playguide/db/item/53b2d7504a1/";
        };
    };

    context 'case call miraprisnap_url' => sub {
        it 'when returns miraprisnap keyword search url' => sub {
            my $url = $hash->{item}->miraprisnap_url;
            is $url, "https://mirapri.com/?keyword=%E3%83%A9%E3%83%A9%E3%83%95%E3%82%A7%E3%83%AB%E3%82%AB%E3%83%95%E3%82%BF%E3%83%B3";
        };
    };

};

runtests unless caller;
