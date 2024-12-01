use 5.40.0;
use Test2::V0;
use Test2::Tools::ClassicCompare qw/is_deeply/;
use Test2::Tools::Spec;
use Test2::Tools::Warnings qw/warning/;

use Oden::Dispatcher;

describe 'about Oden::Dispatcher::dispatch' => sub {
    my $hash;

    before_all "setup" => sub {
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

    describe 'Positive testing' => sub {
        describe 'GLOBAL VARIABLE' => sub {
            it 'hash.dispatcher and $DISPATCH are same' => sub {
                is_deeply $hash->{dispatcher}, $Oden::Dispatcher::DISPATCH, 'same';
            };
        };

        describe 'case commands are exist' => sub {
            it 'should return class name' => sub {
                for my ($key, $value) (%{$hash->{dispatcher}}) {
                    my $class_name = "Oden::Command::$value";
                    my $package    = Oden::Dispatcher->dispatch($key);
                    is $package, $class_name, $key;
                };
            };
        };

        describe 'case command is not exists' => sub {
            it 'should return undef' => sub {
                my $package = Oden::Dispatcher->dispatch('not_exist');
                is $package, undef, 'undef';
            };
        };

        describe "cant load package" => sub {
            it 'should throw exception' => sub {
                local $Oden::Dispatcher::DISPATCH = +{
                    'not_exist' => 'NotExist',
                };

                my $warning = warning {
                    my $package = Oden::Dispatcher->dispatch('not_exist');
                };
                like $warning , qr/Can't locate Oden\/Command\/NotExist.pm in \@INC/, 'throw and warning';
            };
        };
    };
};

done_testing;
