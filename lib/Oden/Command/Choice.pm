package Oden::Command::Choice;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use List::Util qw/shuffle/;
use Oden::Entity::CommunicationEmitter;
use Types::Standard -types;

use constant {
    "Oden::Entity::CommunicationReceiver" => InstanceOf['Oden::Entity::CommunicationReceiver'],
    "Oden::Entity::CommunicationEmitter"  => InstanceOf['Oden::Entity::CommunicationEmitter'],
};

=head1 NAME

  Oden::Command::Place - random choice

=head1 DESCRIPTION

  Oden::Command::Place is random sampling.

=cut

=head1 METHODS

=head2 run

  Its main talking method.

=cut

fun run(ClassName $class, Oden::Entity::CommunicationReceiver $receiver) : Return(Oden::Entity::CommunicationEmitter) {
    my $message = $receiver->message;
    my $entity  = Oden::Entity::CommunicationEmitter->new();

    $entity->message(
        List::Util::shuffle(split /[\s,]+/, $message) || '',
    );

    return $entity;
}
