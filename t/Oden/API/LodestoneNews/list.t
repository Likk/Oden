use strict;
use warnings;
use utf8;

use Test::Spec;
use Test::Exception;
use Test::Warn;

use String::Random;
use Oden::API::LodestoneNews;

describe 'about Oden::API::LodestoneNews#list' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        # create response data.
        my $news = +{};
        for my $locale (qw/na eu fr de jp/) {
            for my $category (qw/topics notices maintenance updates status developers/) {
                for my $recod (0..19) {
                    my $id = String::Random->new->randregex('[A-Za-z0-9]{40}');
                    $news->{$locale}->{$category}->[$recod] = +{
                        id    => $id,
                        url   => sprintf('https://%s.finalfantasyxiv.com/lodestone/%s/detail/%s' =>
                            $locale,
                            $category,
                            $id
                        ),
                        title        => String::Random->new->randregex('[_A-Za-z]{20}'),
                        time         => time(),
                        img          => sprintf('https://img.finalfantasyxiv.com/t/%s.jpg' => $id),
                        description => String::Random->new->randregex('[_A-Za-z]{100}'),
                    };
                }
            }
        }
        $hash->{news} = $news;
    };

    context "Negative testing" => sub {
        context "HTTP::Request resopnse is not 200" => sub {
            before all => sub {
                $hash->{stubs}->{FurlRequest} = Furl->stubs(+{
                    request => sub {
                        Furl::Response->new(
                            503,
                            '503 Service Unavailable',
                            "Service Unavailable",
                            +{
                                'content-type' => 'application/json'
                            },
                            q|{"message": "503 Service Unavailable", "code": 0}|
                        );
                    },
                });
            };

            after all => sub {
                delete $hash->{stubs}->{furlResponse};
            };

            it 'return error message' => sub {
                warning_like {
                    my $res = Oden::API::LodestoneNews->list();
                    is_deeply $res, +{}, 'return empty hash';
                } qr/503 Service Unavailable/;
            };
        };

        context "HTTP::Request resopnse is not JSON" => sub {
            before all => sub {
                $hash->{stubs}->{FurlRequest} = Furl->stubs(+{
                    request => sub {
                        Furl::Response->new(
                            200,
                            '200 OK',
                            "OK",
                            +{
                                'content-type' => 'application/json'
                            },
                            q|not json|
                        );
                    },
                });
            };

            after all => sub {
                delete $hash->{stubs}->{furlResponse};
            };

            it 'return error message' => sub {
                warning_like {
                    my $res = Oden::API::LodestoneNews->list();
                    is_deeply $res, +{}, 'return empty hash';
                } qr/'null' expected, at character offset 0 \(before "not json"\)/;
            };
        };
    };

    context "Positive testing" => sub {
        context 'default parametor' => sub {
            before all => sub {
                $hash->{stubs}->{_request} = Oden::API::LodestoneNews->stubs(+{
                    _request => sub {
                        $hash->{requset_url} = $_[1];
                        return +{
                        };
                    },
                });
            };

            after all => sub {
                delete $hash->{stubs}->{_request};
            };

            it 'category is all, locale is na, limit is 20' => sub {
                my $res = Oden::API::LodestoneNews->list();
                my $requset_url = $hash->{requset_url};
                is $requset_url, 'https://lodestonenews.com/news/all?locale=na&limit=20'
            };
        };

        context 'set parametor' => sub {
            before all => sub {
                $hash->{stubs}->{_request} = Oden::API::LodestoneNews->stubs(+{
                    _request => sub {
                        my ($self, $url) = @_;
                        if( $url =~ m{^https://lodestonenews.com/news/(all|topics|notices|maintenance|updates|status|developers)\?locale=(na|eu|fr|de|jp)&limit=(\d+)$} ) {
                            my ($category, $locale, $limit) = ($1, $2, $3);
                            my $news = $hash->{news};
                            for my $locale (qw/na eu fr de jp/) {
                                for my $category (qw/topics notices maintenance updates status developers/) {
                                    $#{$news->{$locale}->{$category}} = $limit - 1;
                                }
                            }
                            my $locale_news = $category eq 'all' ? $news->{$locale} : $news->{$locale}->{$category};
                            return $locale_news;
                        }
                        return +{};
                    },
                });
            };

            after all => sub {
                delete $hash->{stubs}->{_request};
            };
            context 'category value' => sub {
                it 'all' => sub {
                    my $res = Oden::API::LodestoneNews->list('all');
                    is_deeply $res, $hash->{news}->{na};
                };

                they 'topics', 'notices', 'maintenance', 'updates', 'status', 'developers' => sub {
                    for my $category (qw/topics notices maintenance updates status developers/) {
                        my $res = Oden::API::LodestoneNews->list($category);
                        is_deeply $res, +{ $category => $hash->{news}->{na}->{$category} }, sprintf('category is %s', $category);
                    };
                };
            };

            context 'locale value' => sub {
                they 'na', 'eu', 'fr', 'de', 'jp' => sub {
                    for my $locale (qw/na eu fr de jp/) {
                        my $res = Oden::API::LodestoneNews->list('all', $locale);
                        is_deeply $res, $hash->{news}->{$locale}, sprintf('locale is %s', $locale);
                    };
                };
            };

            context 'limit value' => sub {
                they '1..20' => sub {
                    for my $limit (1..20) {
                        my $res = Oden::API::LodestoneNews->list('all', 'na', $limit);
                        is scalar @{$res->{topics}}, $limit, sprintf('limit is %d', $limit);
                    };
                };
            };

        };
    };
};

runtests();
