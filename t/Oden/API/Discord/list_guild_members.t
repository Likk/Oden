use strict;
use warnings;
use utf8;

use Test::Spec;
use Test::Exception;
use Test::Warn;
use Furl::Response;
use Oden::API::Discord;

describe 'about Oden::API::Discord#list_guild_members' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{invalid_token}    = 'this_is_invalid_token';
        $hash->{unknown_guild_id} = 000;
        $hash->{invalid_guild_id} = 111;

        $hash->{valid_token}    = 'this_is_valid_token';
        $hash->{valid_guild_id} = 999;
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
                        my $res = $hash->{api}->list_guild_members($hash->{valid_guild_id});
                    is $res, undef;
                } [qr/401/, qr/Unauthorized/];
            };
        };

        context "case unknown guild_id" => sub {
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
                            q|{"message": "Unknown Guild", "code": 10004}|
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return undef and warnings' => sub {
                warnings_like {
                    my $res = $hash->{api}->list_guild_members($hash->{unknown_guild_id});
                    is $res, undef;
                } [qr/404/, qr/Not Found/];
            };
        };

        context "case missing access" => sub {
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
                            q|{"message": "Unknown Guild", "code": 10004}|
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return undef and warnings' => sub {
            warnings_like {
                    my $res = $hash->{api}->list_guild_members($hash->{invalid_guild_id});
                    is $res, undef;
                } [qr/404/, qr/Not Found/];

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
                    $hash->{api}->list_guild_members();
                } qr/Too few arguments for method list_guild_members/;
            };
        };
    };

    context "Positive testing" => sub {
        context "case guild_id is valid" => sub {
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
                            q|[{"avatar": null,"nick": null,"pending": false,"user": {"id": "111","username": "name","bot": true}}]|
                        );
                    },
                });

                yield;

                delete $hash->{api};
                delete $hash->{stubs}->{furl};
            };
            it 'when return user object' => sub {
                my $res = $hash->{api}->list_guild_members($hash->{valid_guild_id});
                isa_ok $res, 'ARRAY';
                is $res->[0]->{user}->{id}, '111';
                is $res->[0]->{user}->{username}, 'name';
            };
        };
    };
};

runtests();
