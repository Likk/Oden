use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::Bot;

describe 'about Oden::Bot#talk' => sub {
    my $hash = {};

    describe 'Negative testing' => sub {
        describe 'when parameter is not set' => sub {
            it 'should exception' => sub {
                my $throw = dies {
                    Oden::Bot->talk;
                };
                like $throw, qr/Too few arguments for method talk/;
            };
        };
        describe 'when content is not set' => sub {
            it 'should exception' => sub {
                my $throw = dies {
                    Oden::Bot->talk(undef, 1, 'username');
                };
                like $throw, qr/did not pass type constraint "Str"/;
            };
        };
        describe 'when guild_id is not set' => sub {
            it 'should exception' => sub {
                my $throw = dies {
                    Oden::Bot->talk('content', undef, 'username');
                };
                like $throw, qr/did not pass type constraint "Int"/;
            };
        };
        describe 'when username is not set' => sub {
            it 'should exception' => sub {
                my $throw = dies {
                    Oden::Bot->talk('content', 1, undef);
                };
                like $throw, qr/did not pass type constraint "Str"/;
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'when parameter is set' => sub {
            describe 'when content is ""' => sub {
                it 'should return undef' => sub {
                    my $res = Oden::Bot->talk('', 1, 'username');
                    is $res, undef, 'no response';
                };
            };
            describe 'when content is "slashCommand"' => sub {
                before_all 'create mock' => sub {
                    $hash->{mock} = mock "Oden::Dispatcher" => (
                        override => [
                            dispatch => sub {
                                my ($class, $command) = @_;
                                my $package = sprintf('Oden::Command::%s', ucfirst($command));
                                my $self =  bless {} , $package;

                                no strict 'refs';
                                my $subname = sprintf("%s::run", $package);
                                *{$subname} = sub {
                                    return sprintf("response %s", $command);
                                };

                                return $self;
                            }
                        ]
                    );
                };
                it 'should return response' => sub {
                    my $res = Oden::Bot->talk('/SlashCommand', 1, 'username');
                    is $res, 'response SlashCommand', 'response is "response SlashCommand"';
                };
            };
        };
    };
};

done_testing;
