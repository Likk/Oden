use strict;
use warnings;
use utf8;
use Test::Exception;
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
            'place'      => 'Place',
            'choice'     => 'Place',
            'dice'       => 'Dice',
            'group'      => 'Group',
        };
    };

    #context 'Negative testing' => sub {
    #};

    context 'Positive testing' => sub {
        context 'GLOBAL VARIABLE' => sub {
            it 'hash.dispatcher and $DISPATCH are same' => sub {
                is_deeply $hash->{dispatcher}, $Oden::Dispatcher::DISPATCH, 'same';
            };
        };

        context 'case commands are exist' => sub {
            they 'should return class name' => sub {
                for my ($key) (keys %{$hash->{dispatcher}}) {
                    my $command    = $hash->{dispatcher}->{$key};
                    my $class_name = "Oden::Command::$command";
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
    };
};

runtests;
