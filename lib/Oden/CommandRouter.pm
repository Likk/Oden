package Oden::CommandRouter;
use 5.40.0;
use builtin qw(load_module);
no warnings 'experimental::builtin';

use Function::Parameters;
use Function::Return;
use Module::Pluggable::Object;
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

=cut

=head1 Accessors

=cut

use Class::Accessor::Lite (
    rw  => [qw/
        command_search_path
        fast_passive_commands
        passive_commands
        active_commands
    /],
);

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  create and return a new router object.

=cut

method new($class: %args) :Return(InstanceOf['Oden::CommandRouter']) {
    my $self = bless { %args }, $class;
    $self->setup();
    return $self;
}

=head2 setup

  Load all the classes in the Oden::Command namespace and register the command name.

=cut

method setup() :Return(Bool) {
    my $command_search_path = $self->command_search_path || ['Oden::Command'];
    my $pluggable = Module::Pluggable::Object->new(
        search_path => $command_search_path,
    );
    my $plguins = [$pluggable->plugins];
    for my $package (@$plguins) {
        load_module($package);

        my $command_type =  $package->command_type();
        my $command_list =  $package->command_list();

        # passive commands
        if($command_type eq 'fast_passive'){
            my $route_fast_passive = $self->fast_passive_commands() || [];
            push @$route_fast_passive, $package;
            $self->fast_passive_commands($route_fast_passive);
        }

        # active commands
        for my $command (@$command_list) {
            my $command_router = $self->active_commands() || +{};
            $command_router->{$command} = $package;
            $self->active_commands($command_router);
        }

    }
    return 1;
}

=head1 CLASS METHODS

=head2 route_active

  route_active method returns the class name that corresponds to the command name.

=cut

method route_active(Str $command) :Return(Maybe[ClassName]) {
    my $package = $self->active_commands->{$command};
    return undef unless $package;
    return $package;
}
