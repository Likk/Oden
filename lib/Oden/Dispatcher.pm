package Oden::Dispatcher;
use 5.40.0;
use feature qw(try);

use Function::Parameters;
use Function::Return;
use Module::Load;
use Types::Standard -types;

=encoding utf8

=head1 NAME

  Oden::Dispatcher

=head1 DESCRIPTION

  Oden::Dispatcher is a class designed to dispatch commands to the appropriate class.

=head1 SYNOPSIS

  my $dispatcher = Oden::Dispatcher->new();
  my $class      = $dispatcher->dispatch('itemsearch');
  # $class is Oden::Command::ItemSearch

=head1 GLOBAL VARIABLE

=over

=item B<DISPATCH>

  This global variable is a hash reference that maps command names to class names.

=back

=cut

our $DISPATCH = +{
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

=head1 CLASS METHODS

=head2 dispatch

  dispatch method returns the class name that corresponds to the command name.

=cut

fun dispatch(ClassName $class, Str $command) :Return(Maybe[ClassName]) {
    my $dispatched = $DISPATCH->{$command};
    return undef unless $dispatched;

    my $package = sprintf("Oden::Command::%s", $dispatched);

    try {
        autoload($package);
    }
    catch ($e) {
        warn $e;
        return undef;
    };
    return $package;
}
