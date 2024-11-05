use strict;
use warnings;
use utf8;

use Test::Spec;
use Test::Exception;
use Test::Warn;
use Furl::Response;
use Oden::API::Discord;

describe 'about Oden::API::Discord#send_attached_file' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{invalid_token}      = 'this_is_invalid_token';
        $hash->{unknown_channel_id} = 000;
        $hash->{invalid_channel_id} = 111;
        $hash->{not_found_file}     = '__not_found_file.txt';

        $hash->{valid_token}      = 'this_is_valid_token';
        $hash->{valid_channel_id} = 999;
        $hash->{path}             = './t/Oden/API/Discord/__attach_test_file.txt';
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
                    my $res = $hash->{api}->send_attached_file(
                        $hash->{valid_channel_id},
                        $hash->{path}
                    );
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
                    my $res = $hash->{api}->send_attached_file(
                        $hash->{unknown_channel_id},
                        $hash->{path}
                    );
                    is $res, undef;
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
            it 'when return undef and warnings' => sub {
                warnings_like {
                    my $res = $hash->{api}->send_attached_file(
                        $hash->{invalid_channel_id},
                        $hash->{path}
                    );
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
                    $hash->{api}->send_attached_file();
                } qr/Too few arguments for method send_attached_file/;
            };
        };

        context "case path is not set" => sub {
            around {
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                yield;

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                throws_ok {
                    $hash->{api}->send_attached_file($hash->{valid_channel_id});
                } qr/Too few arguments for method send_attached_file/;
            };
        };

        context "case path is not found" => sub {
            around {
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                yield;

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                throws_ok {
                    $hash->{api}->send_attached_file(
                        $hash->{valid_channel_id},
                        $hash->{not_found_file},
                    );
                } qr/No such file or directory/;
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
                            q|{"content":"test_message","mentions":[],"attachments":[],"id":"1111","channel_id":"999","attachments":[{"id":"9999","filename":"attach_test_file.txt","size":26,"url":"https://cdn.example.com/attachments/999/9999/attach_test_file.txt?ex=hash&is=hash&","content_type":"text/plain; charset=utf-8","content_scan_version":0,"title":"__attach_test_file"}],"author":{"id":"9999","username":"nickname","public_flags":0,"flags":0,"bot":true}}|
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return user object' => sub {
                my $res = $hash->{api}->send_attached_file(
                    $hash->{valid_channel_id},
                    $hash->{path}
                );
                is $res, 1;
            };
        };
    };
};

runtests();
