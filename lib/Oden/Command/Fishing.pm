package Oden::Command::Fishing;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use Oden::Entity::CommunicationEmitter;
use Oden::Model::Item;
use Types::Standard -types;

use constant {
    "Oden::Entity::CommunicationReceiver" => InstanceOf['Oden::Entity::CommunicationReceiver'],
    "Oden::Entity::CommunicationEmitter"  => InstanceOf['Oden::Entity::CommunicationEmitter'],
};

=head1 NAME

  Oden::Command::Fishing - show fishing informatin on teamcraft.

=head1 DESCRIPTION

  Oden::Command::ItemSearch is provide URL of ffxivteamcraft from item name

=cut

=head1 METHODS

=head2 run

  Its main talking method.

=cut

fun run(ClassName $class, Oden::Entity::CommunicationReceiver $receiver) : Return(Oden::Entity::CommunicationEmitter) {
    my $hear = $receiver->message;
    my $entity = Oden::Entity::CommunicationEmitter->new();

    return $entity unless $hear;
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
