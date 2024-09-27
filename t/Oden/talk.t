use strict;
use warnings;
use utf8;
use Test::Exception;
use Test::Spec;
use Oden;

describe 'about Oden#talk' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{oden} = Oden->new;
    };

    context 'Negative testing' => sub {
        context 'when parameter is not set' => sub {
            it 'should exception' => sub {
                throws_ok {
                    $hash->{oden}->talk;
                } qr/Too few arguments for method talk/;
            };
        };
        context 'when content is not set' => sub {
            it 'should exception' => sub {
                throws_ok {
                    $hash->{oden}->talk(undef, 1, 'username');
                } qr/did not pass type constraint "Str"/;
            };
        };
        context 'when guild_id is not set' => sub {
            it 'should exception' => sub {
                throws_ok {
                    $hash->{oden}->talk('content', undef, 'username');
                } qr/did not pass type constraint "Int"/;
            };
        };
        context 'when username is not set' => sub {
            it 'should exception' => sub {
                throws_ok {
                    $hash->{oden}->talk('content', 1, undef);
                } qr/did not pass type constraint "Str"/;
            };
        };
    };

    context 'Positive testing' => sub {
        context 'when parameter is set' => sub {
            context 'when content is ""' => sub {
                it 'should return undef' => sub {
                    my $oden = $hash->{oden};
                    my $res = $oden->talk('', 1, 'username');
                    is $res, undef, 'no response';
                };
            };
            context 'when content is "slashCommand"' => sub {
                before all => sub {
                    $hash->{stubs} = Oden::Dispatcher->stubs(+{
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
                    });
                };
                it 'should return response' => sub {
                    my $oden = $hash->{oden};
                    my $res = $oden->talk('/SlashCommand', 1, 'username');
                    is $res, 'response SlashCommand', 'response is "response SlashCommand"';
                };
            };
        };
    };
};

runtests;
