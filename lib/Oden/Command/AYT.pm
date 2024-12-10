package Oden::Command::AYT;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use Oden::Entity::CommunicationEmitter;
use Types::Standard -types;

use constant {
    "Oden::Entity::CommunicationReceiver" => InstanceOf['Oden::Entity::CommunicationReceiver'],
    "Oden::Entity::CommunicationEmitter"  => InstanceOf['Oden::Entity::CommunicationEmitter'],
};

=head1 NAME

  Oden::Command::AYT - are you there.

=head1 DESCRIPTION

  Oden::Command::AYT is ping for Oden.

=cut

=head1 METHODS

=head2 command_type

  Any of `active`, `fast_passive` and `passive`

=cut

fun command_type(ClassName $class) :Return(Str) {
    return 'fast_passive';
}

fun command_list(ClassName $class) :Return(ArrayRef[Str]) {
    return [qw/ayt/];
}

=head2 run

  Its main talking method.
  If you say 'Are You There?' to Oden, Oden will respond with '[yes]'.

=cut

fun run(ClassName $class, Oden::Entity::CommunicationReceiver $receiver) :Return(Maybe[Oden::Entity::CommunicationEmitter]) {
    my $message = $receiver->message;
    return undef unless $message;
    if ($message =~ m{^([/!])?(A(?:re)*|R)(?:\s*)(Y(?:ou)*|U)(?:\s*)T(?:here)?(?:\?)?$}i) {
        my $entity = Oden::Entity::CommunicationEmitter->new();
        $entity->message('[yes]');
        return $entity;
    }
    return undef;
}

=head1 SEE ALSO

  Oden

=cut
