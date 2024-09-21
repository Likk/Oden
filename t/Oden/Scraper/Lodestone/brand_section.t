use 5.40.0;
use Test::Spec;

use Oden::Scraper::Lodestone;

describe 'about Oden::Scraper::Lodestone#brand_section' => sub {
    my $hash;
    share %$hash;

    context 'case call method' => sub {
        before all => sub {
            my $lodestone = Oden::Scraper::Lodestone->new;
            $hash->{lodestone} = $lodestone;
        };
        it 'when returns brand section' => sub {
            my $lodestone = $hash->{lodestone};
            isa_ok $lodestone, 'Oden::Scraper::Lodestone';

            my $res = $lodestone->brand_section();

            isa_ok $res, 'HASH';
            is     $res->{url},   'http://www.jp.square-enix.com/',                                         'url correct';
            is     $res->{image}, 'https://lds-img.finalfantasyxiv.com/h/L/cxcD5kjeM52JRVwrrzIF4dZNe0.png', 'image correct';
            is     $res->{alt},   'SQUARE ENIX',                                                            'alt correct';
        };
    };
};

runtests();
