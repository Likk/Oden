package Oden::Dispatcher;
use strict;
use warnings;

use Module::Load;

our $DISPATCH = +{
    'itemsearch' => 'ItemSearch',
    'isearch'    => 'ItemSearch',
    'is'         => 'ItemSearch',
    'fishing'    => 'Fishing',
    'market'     => 'MarketBoard',
    'dict'       => 'Dictionary',
};

sub dispatch {
    my ($class, $command) = @_;
    my $dispatched = $DISPATCH->{$command} or return;

    my $package = sprintf("Oden::Command::%s", $dispatched);

    eval {
        autoload($package);
    };
    if($@){
        warn $@;
        return;
    }
    return $package;
}
