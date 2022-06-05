use strict;
use warnings;
use utf8;

use Test::Spec;

use Oden::Model::Item;

describe 'about Oden::Model::Item#(.+)_url ja' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{item} = Oden::Model::Item->lookup_item_by_name('ララフェルカフタン');
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

describe 'about Oden::Model::Item#(.+)_url en' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{item} = Oden::Model::Item->lookup_item_by_name('Lalafellin Kaftan');
    };

    context 'case call lodestone_url' => sub {
        it 'when returns offical lodestone url' => sub {
            my $url = $hash->{item}->lodestone_url;
            is $url, "https://na.finalfantasyxiv.com/lodestone/playguide/db/item/53b2d7504a1/";
        };
    };

    context 'case call miraprisnap_url' => sub {
        it 'when returns miraprisnap keyword search url' => sub {
            my $url = $hash->{item}->miraprisnap_url;
            is $url, "https://mirapri.com/?keyword=%E3%83%A9%E3%83%A9%E3%83%95%E3%82%A7%E3%83%AB%E3%82%AB%E3%83%95%E3%82%BF%E3%83%B3";
        };
    };

};

describe 'about Oden::Model::Item#(.+)_url de' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{item} = Oden::Model::Item->lookup_item_by_name('Lalafell-Kaftan');
    };

    context 'case call lodestone_url' => sub {
        it 'when returns offical lodestone url' => sub {
            my $url = $hash->{item}->lodestone_url;
            is $url, "https://de.finalfantasyxiv.com/lodestone/playguide/db/item/53b2d7504a1/";
        };
    };

    context 'case call miraprisnap_url' => sub {
        it 'when returns miraprisnap keyword search url' => sub {
            my $url = $hash->{item}->miraprisnap_url;
            is $url, "https://mirapri.com/?keyword=%E3%83%A9%E3%83%A9%E3%83%95%E3%82%A7%E3%83%AB%E3%82%AB%E3%83%95%E3%82%BF%E3%83%B3";
        };
    };

};

describe 'about Oden::Model::Item#(.+)_url fr' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{item} = Oden::Model::Item->lookup_item_by_name('Caftan lalafell');
    };

    context 'case call lodestone_url' => sub {
        it 'when returns offical lodestone url' => sub {
            my $url = $hash->{item}->lodestone_url;
            is $url, "https://fr.finalfantasyxiv.com/lodestone/playguide/db/item/53b2d7504a1/";
        };
    };

    context 'case call miraprisnap_url' => sub {
        it 'when returns miraprisnap keyword search url' => sub {
            my $url = $hash->{item}->miraprisnap_url;
            is $url, "https://mirapri.com/?keyword=%E3%83%A9%E3%83%A9%E3%83%95%E3%82%A7%E3%83%AB%E3%82%AB%E3%83%95%E3%82%BF%E3%83%B3";
        };
    };

};


describe 'about Oden::Model::Item#miraprisnap_url ja' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{item} = Oden::Model::Item->lookup_item_by_name('アンティークメイル');
    };

    context 'case call miraprisnap_url' => sub {
        it 'when returns undef. it is not equipment item' => sub {
            my $url = $hash->{item}->miraprisnap_url;
            is $url, undef;
        };
    };

};

runtests unless caller;
