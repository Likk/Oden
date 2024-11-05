use strict;
use warnings;
use utf8;

use Test::Spec;
use Test::Exception;
use Test::Warn;
use Furl::Response;
use Oden::API::Discord;

describe 'about Oden::API::Discord#show_user' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{invalid_token}   = 'dummy';
        $hash->{unknown_user_id} = 000;

        $hash->{valid_token}     = 'this_is_valid_token';
        $hash->{valid_user_id}   = 999;
    };

    context "Negative testing" => sub {
        context "case token is not valid" => sub {
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
                    my $res = $hash->{api}->show_user($hash->{valid_user_id});
                    is $res, undef;
                } [qr/401/, qr/Unauthorized/];
            };
        };

        context "case unknown user_id" => sub {
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
                            q|{"message": "Unknown User", "code": 10013}|
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return undef and warnings' => sub {
                warnings_like {
                    my $res = $hash->{api}->show_user($hash->{unknown_user_id});
                    is $res, undef;
                } [qr/404/, qr/Not Found/];
            };
        };

        context "case user_id is not set" => sub {
            around {
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                yield;

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                throws_ok {
                    $hash->{api}->show_user();
                } qr/Too few arguments for method show_user/;
            };
        };
    };

    context "Positive testing" => sub {
        context "case user_id is valid" => sub {
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
                            q|{"id": "999", "username": "nickname"}|
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return user object' => sub {
                my $res = $hash->{api}->show_user($hash->{valid_user_id});
                is $res->{id},       $hash->{valid_user_id};
                is $res->{username}, 'nickname';
            };
        };
    };
};

runtests();
