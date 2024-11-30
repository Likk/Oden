use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;
use Test2::Tools::Warnings qw/warnings/;

use Furl::Response;
use Oden::API::Discord;

describe 'about Oden::API::Discord#show_channel' => sub {
    my $hash;

    before_all "setup" => sub {
        $hash->{invalid_token}      = 'this_is_invalid_token';
        $hash->{invalid_channel_id} = 111;

        $hash->{valid_token}        = 'this_is_valid_token';
        $hash->{valid_channel_id}   = 999;
    };

    describe "Negative testing" => sub {
        describe "case token is invalid" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api}           = Oden::API::Discord->new(token => $hash->{invalid_token}, interval => 0);
                $hash->{stubs}->{furl} = mock "Furl" => (
                    override => [
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
                    ],
                );

                $tests->();

                delete $hash->{api};
                delete $hash->{stubs}->{furl};

            };

            it 'when return undef and warnings' => sub {
                my $warnings = warnings {
                    my $res = $hash->{api}->show_channel($hash->{valid_channel_id});
                    is $res, undef;
                };

                like $warnings->[0], qr/401/;
                like $warnings->[1], qr/Unauthorized/;
            };
        };

        describe "case unknown channel_id" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                $hash->{stubs}->{furl} = mock "Furl" => (
                    override => [
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
                    ],
                );

                $tests->();

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return undef and warnings' => sub {
                my $warnins = warnings {
                    my $res = $hash->{api}->show_channel(000);
                    is $res, undef;
                };

                like $warnins->[0], qr/404/;
                like $warnins->[1], qr/Not Found/;
            };
        };

        describe "case unauthorized" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                $hash->{stubs}->{furl} = mock "Furl" => (
                    override => [
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
                    ],
                );

                $tests->();

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return undef and warnings' => sub {
                my $warnins = warnings {
                    my $res = $hash->{api}->show_channel($hash->{invalid_channel_id});
                    is $res, undef;
                };

                like $warnins->[0], qr/403/;
                like $warnins->[1], qr/Forbidden/;
            };
        };

        describe "case channel_id is not set" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);

                $tests->();

                delete $hash->{api};
            };
            it 'when throw exception' => sub {
                my $throws = dies {
                    $hash->{api}->show_channel();
                };
                like $throws, qr/Too few arguments for method show_channel/;
            };
        };
    };

    describe "Positive testing" => sub {
        describe "case channel_id is valid" => sub {
            around_all "mockup" => sub {
                my $tests = shift;
                $hash->{api} = Oden::API::Discord->new(token => $hash->{valid_token}, interval => 0);
                $hash->{stubs}->{furl} = mock "Furl" => (
                    override => [
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
                    ],
                );

                $tests->();

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

done_testing();
