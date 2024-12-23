package Oden::Command::Fishing;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use Module::Load qw(autoload);
use Dashi::Entity::CommunicationEmitter;
use Types::Standard -types;

use constant {
    "Dashi::Entity::CommunicationReceiver" => InstanceOf['Dashi::Entity::CommunicationReceiver'],
    "Dashi::Entity::CommunicationEmitter"  => InstanceOf['Dashi::Entity::CommunicationEmitter'],
};

=head1 NAME

  Oden::Command::Fishing - show fishing informatin on teamcraft.

=head1 DESCRIPTION

  Oden::Command::ItemSearch is provide URL of ffxivteamcraft from item name

=cut

=head1 METHODS

=head2 command_type

  Any of `active`, `fast_passive` and `passive`

=cut

fun command_type(ClassName $class) : Return(Str) {
    return 'active';
}

fun command_list(ClassName $class) : Return(ArrayRef[Str]) {
    return [qw/fishing/];
}

=head2 run

  Its main talking method.

=cut

fun run(ClassName $class, Dashi::Entity::CommunicationReceiver $receiver) : Return(Dashi::Entity::CommunicationEmitter) {
    my $hear = $receiver->message;
    my $entity = Dashi::Entity::CommunicationEmitter->new();

    return $entity unless $hear;

    #XXX: autoload called only once.
    my $loaded = sub { autoload(Oden::Model::Item); return true }->();

    if(my $item = Oden::Model::Item->lookup_item_by_name($hear)){
        $entity->message(
            sprintf("teamcraft: %s\n", $item->ffxivteamcraft_url)
        ) if $item->ffxivteamcraft_url;
    }
    return $entity;
}

=head1 SEE ALSO

  Oden::Model::Item

=cut
