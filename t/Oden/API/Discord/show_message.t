use strict;
use warnings;
use utf8;

use Test::Spec;
use Test::Exception;
use Test::Warn;
use Furl::Response;
use Oden::API::Discord;

describe 'about Oden::API::Discord#show_message' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{invalid_token}      = 'this_is_invalid_token';
        $hash->{invalid_channel_id} = 111;
        $hash->{invalid_message_id} = 1111;

        $hash->{valid_token}        = 'this_is_valid_token';
        $hash->{valid_channel_id}   = 999;
        $hash->{valid_message_id}   = 9999;
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
                    my $res = $hash->{api}->show_message(
                        $hash->{valid_channel_id},
                        $hash->{valid_message_id}
                    );
                    is $res, undef;
                } [qr/401/, qr/Unauthorized/];
            };
        };

        context "case unknown message_id" => sub {
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
                            q|{"message": "Unknown Message", "code": 10008}|
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return undef and warnings' => sub {
                warnings_like {
                    my $res = $hash->{api}->show_message(
                        $hash->{valid_channel_id},
                        000, # is not exists message_id
                    );
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
                            q|{"message": "Missing Access", "code": 50001}}|
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return undef and warnings' => sub {
                warnings_like {
                    my $res = $hash->{api}->show_message(
                        $hash->{invalid_channel_id},
                        $hash->{valid_message_id}
                    );
                    is $res, undef;
                } [qr/403/, qr/Forbidden/];

            };
        };

        context "case channel_id and message_id are not set" => sub {
            around {
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                yield;

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                throws_ok {
                    $hash->{api}->show_message();
                } qr/Too few arguments for method show_message/;
            };
        };
        context "case message_id is not set" => sub {
            around {
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                yield;

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                throws_ok {
                    $hash->{api}->show_message($hash->{valid_channel_id});
                } qr/Too few arguments for method show_message/;
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
                            q|{"content":"test message","mentions":[],"mention_roles":[],"attachments":[],"embeds":[],"flags":0,"components":[],"id":"222","channel_id":"111","author":{"id":"333","username":"nick"}}|
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return user object' => sub {
                my $res = $hash->{api}->show_message(
                    $hash->{valid_channel_id},
                    $hash->{valid_message_id}
                );
                is $res->{content},            'test message';
                is $res->{channel_id},         $hash->{valid_channel_id};
                is $res->{id},                 $hash->{valid_message_id};
                is $res->{author}->{id},       '333';
                is $res->{author}->{username}, 'nick';

            };
        };
    };
};

runtests();
