use strict;
use warnings;
use utf8;

use Test::Spec;
use Test::Exception;
use Test::Warn;
use Furl::Response;
use Oden::API::Discord;

describe 'about Oden::API::Discord#show_channel' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{invalid_token}      = 'this_is_invalid_token';
        $hash->{invalid_channel_id} = 111;

        $hash->{valid_token}        = 'this_is_valid_token';
        $hash->{valid_channel_id}   = 999;
    };

    context "Negative testing" => sub {
        context "case token is invalid" => sub {
            around {
                $hash->{api} = Oden::API::Discord->new(token => $hash->{invalid_token}, interval => 0);

                $hash->{stubs}->{furl} = Furl->stubs(+{
                    request => sub {
                        Furl::Response->new(
                            1,
                            '401',
                            "Unauthorized",
                            +{
                                'content-type' => 'application/json'
                            },
                            q|{"message": "401: Unauthorized", "code": 0}|
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};

            };

            it 'when return undef and warnings' => sub {
                warnings_like {
                    my $res = $hash->{api}->show_channel($hash->{valid_channel_id});
                    is $res, undef;
                } [qr/401/, qr/Unauthorized/];
            };
        };

        context "case unknown channel_id" => sub {
            around {
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                $hash->{stubs}->{furl} = Furl->stubs(+{
                    request => sub {
                        Furl::Response->new(
                            1,
                            '404',
                            "Not Found",
                            +{
                                'content-type' => 'application/json'
                            },
                            q|{"message": "Unknown Channel", "code": 10003}|
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return undef and warnings' => sub {
                warnings_like {
                    my $res = $hash->{api}->show_channel(000);
                    is $res, undef;
                } [qr/404/, qr/Not Found/];

            };
        };

        context "case unauthorized" => sub {
            around {
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                $hash->{stubs}->{furl} = Furl->stubs(+{
                    request => sub {
                        Furl::Response->new(
                            1,
                            '403',
                            "Forbidden",
                            +{
                                'content-type' => 'application/json'
                            },
                            q|{"message": "Missing Access", "code": 50001}|
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return undef and warnings' => sub {
                warnings_like {
                    my $res = $hash->{api}->show_channel($hash->{invalid_channel_id});
                    is $res, undef;
                } [qr/403/, qr/Forbidden/];

            };
        };

        context "case channel_id is not set" => sub {
            around {
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                yield;

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                throws_ok {
                    $hash->{api}->show_channel();
                } qr/Too few arguments for method show_channel/;
            };
        };
    };

    context "Positive testing" => sub {
        context "case channel_id is valid" => sub {
            around {
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);
                $hash->{stubs}->{furl} = Furl->stubs(+{
                    request => sub {
                        Furl::Response->new(
                            1,
                            '200',
                            "OK",
                            +{
                                'content-type' => 'application/json'
                            },
                            q|{"id":"111","type":"0","guild_id":"111","name":"general"}|
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return user object' => sub {
                my $res = $hash->{api}->show_channel($hash->{valid_channel_id});
                is $res->{id},   '111';
                is $res->{name}, 'general';
            };
        };
    };
};

runtests();
