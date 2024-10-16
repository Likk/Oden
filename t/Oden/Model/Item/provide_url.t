use strict;
use warnings;
use utf8;

use Test::Spec;

# import でファイル読み込みを行うので、テストでは直前まで読み込まないようにする
use Oden::Model::Item();

describe 'about Oden::Model::Item#(.+)_url' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        local $ENV{DATA_DIR} = './t/Oden/Model/Item/data';
        Oden::Model::Item->import;
    };

    context "negative testing" => sub {
        before all => sub {
            my $lang_to_name = {
                jp => "アンティークメイル",
                na => "Antique Mail",
                de => "Antike Rüstung",
                fr => "Maille archaïque",
            };
            $hash->{lang_to_name} = $lang_to_name;

        };

        for my $lang (qw/jp na de fr/) {
            context "call miraprisnap_url $lang" => sub {
                before all => sub {
                    $hash->{item} = Oden::Model::Item->lookup_item_by_name($hash->{lang_to_name}->{$lang});
                };
                it "when returns undef. it is not equipment item" => sub {
                    my $url = $hash->{item}->miraprisnap_url;
                    is $url, undef;
                };
            };
        }
    };

    context "positive testing" => sub {
        before all => sub {
            my $lang_to_name = {
                jp => 'ララフェルカフタン',
                na => 'Lalafellin Kaftan',
                de => 'Lalafell-Kaftan',
                fr => 'Caftan lalafell',
            };
            $hash->{lang_to_name} = $lang_to_name;
        };

        for my $lang (qw/jp na de fr/) {
            context "call lodestone_url $lang" => sub {
                before all => sub {
                    $hash->{item} = Oden::Model::Item->lookup_item_by_name($hash->{lang_to_name}->{$lang});
                };
                it "when returns offical lodestone url ($lang)" => sub {
                    my $url = $hash->{item}->lodestone_url;
                    is $url, "https://$lang.finalfantasyxiv.com/lodestone/playguide/db/item/53b2d7504a1/";
                };
            };
        }

        for my $lang (qw/jp na de fr/) {
            context "case call miraprisnap_url $lang" => sub {
                before all => sub {
                    $hash->{item} = Oden::Model::Item->lookup_item_by_name($hash->{lang_to_name}->{$lang});
                };
                it "when returns miraprisnap keyword search url ($lang)" => sub {
                    my $url = $hash->{item}->miraprisnap_url;
                    is $url, "https://mirapri.com/?keyword=%E3%83%A9%E3%83%A9%E3%83%95%E3%82%A7%E3%83%AB%E3%82%AB%E3%83%95%E3%82%BF%E3%83%B3";
                };
            };
        };
    };
};

runtests();
