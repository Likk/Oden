use 5.40.0;
use utf8;

use Test::Spec;
use Test::Exception;
use Test::Warn;
use Furl::Response;
use Oden::API::Discord;

describe 'about Oden::API::Discord#join_thread' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{invalid_token}      = 'this_is_invalid_token';
        $hash->{unknown_thread_id}  = 000;
        $hash->{invalid_thread_id}  = 111;

        $hash->{valid_token}      = 'this_is_valid_token';
        $hash->{valid_channel_id} = 999;
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

            it 'when return false and warnings' => sub {
                warnings_like {
                    my $res = $hash->{api}->join_thread(
                        $hash->{valid_channel_id},
                    );
                    is $res, false;
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
            it 'when return false and warnings' => sub {
                warnings_like {
                    my $res = $hash->{api}->join_thread(
                        $hash->{unknown_thread_id},
                    );
                    is $res, false;
                } [qr/404/, qr/Not Found/];
            };
        };

        context "case invalid channel_id" => sub {
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
            it 'when return false and warnings' => sub {
                warnings_like {
                    my $res = $hash->{api}->join_thread(
                        $hash->{invalid_thread_id},
                    );
                    is $res, false;
                } [qr/403/, qr/Forbidden/];
            };
        };

        context "case thread_id is not set" => sub {
            around {
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                yield;

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                throws_ok {
                    $hash->{api}->join_thread();
                } qr/Too few arguments for method join_thread/;
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
                            '204',
                            "No Content",
                            +{
                                'content-type' => 'text/html; charset=utf-8' #optional. But discord server return this.
                            },
                            ''
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return user object' => sub {
                my $res = $hash->{api}->join_thread(
                    $hash->{valid_channel_id},
                );
                is $res, 1;
            };
        };
    };
};

runtests();
