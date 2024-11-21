use strict;
use warnings;
use utf8;
use Test::Warn;
use Test::Spec;
use Oden::Dispatcher;

describe 'about Oden::Dispatcher::dispatch' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{dispatcher} = +{
            'itemsearch' => 'ItemSearch',
            'isearch'    => 'ItemSearch',
            'is'         => 'ItemSearch',
            'fishing'    => 'Fishing',
            'market'     => 'MarketBoard',
            'dict'       => 'Dictionary',
            'place'      => 'Choice',
            'choice'     => 'Choice',
            'dice'       => 'Dice',
            'group'      => 'Group',
        };
    };

    context 'Positive testing' => sub {
        context 'GLOBAL VARIABLE' => sub {
            it 'hash.dispatcher and $DISPATCH are same' => sub {
                is_deeply $hash->{dispatcher}, $Oden::Dispatcher::DISPATCH, 'same';
            };
        };

        context 'case commands are exist' => sub {
            they 'should return class name' => sub {
                for my ($key, $value) (%{$hash->{dispatcher}}) {
                    my $class_name = "Oden::Command::$value";
                    my $package    = Oden::Dispatcher->dispatch($key);
                    is $package, $class_name, $key;
                };
            };
        };

        context 'case command is not exists' => sub {
            it 'should return undef' => sub {
                my $package = Oden::Dispatcher->dispatch('not_exist');
                is $package, undef, 'undef';
            };
        };

        context "cant load package" => sub {
            before all => sub {
                $Oden::Dispatcher::DISPATCH = +{
                    'not_exist' => 'NotExist',
                };
            };
            it 'should throw exception' => sub {
                warning_like {
                    my $package = Oden::Dispatcher->dispatch('not_exist');
                    is $package, undef, 'undef';
                } qr/Can't locate Oden\/Command\/NotExist.pm in \@INC/, 'throw and warning';
            };
        };
    };
};

runtests;
