package Oden::Command::ItemSearch;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use Module::Load qw(autoload);
use Oden::Entity::CommunicationEmitter;
use Types::Standard -types;

use constant {
    "Oden::Entity::CommunicationReceiver" => InstanceOf['Oden::Entity::CommunicationReceiver'],
    "Oden::Entity::CommunicationEmitter"  => InstanceOf['Oden::Entity::CommunicationEmitter'],
};

=head1 NAME

  Oden::Command::ItemSearch - item search from lodestone.

=head1 DESCRIPTION

  Oden::Command::ItemSearch is provide URL of lodeston from item name.

=cut

=head1 METHODS

=head2 command_type

  Any of `active`, `fast_passive` and `passive`

=cut

fun command_type(ClassName $class) : Return(Str) {
    return 'active';
}

fun command_list(ClassName $class) : Return(ArrayRef[Str]) {
    return [qw/itemsearch isearch is/];
}

=head2 run

  Its main talking method.

=cut

fun run(ClassName $class, Oden::Entity::CommunicationReceiver $receiver) : Return(Oden::Entity::CommunicationEmitter) {
    my $hear = $receiver->message;
    my $entity = Oden::Entity::CommunicationEmitter->new();

    return $entity unless $hear;

    #XXX: autoload called only once.
    state $loaded = sub { autoload(Oden::Model::Item); return true }->();

    if(my $item = Oden::Model::Item->lookup_item_by_name($hear)){
        my $lodestone_url   = $item->lodestone_url;
        my $miraprisnap_url = $item->miraprisnap_url;
        $entity->message(
            ($lodestone_url   ? sprintf("lodestone: %s\n", $lodestone_url)     : '') .
            ($miraprisnap_url ? sprintf("miraprisnap: %s\n", $miraprisnap_url) : '')
        );
        return $entity;
    }

    if(my $candidate = Oden::Model::Item->search_prefix_match_name($hear)){
        $entity->message(
            sprintf("maybe:\n%s", join("\n", @$candidate))
        );
        return $entity;
    }
    return $entity;
}

=head1 SEE ALSO

  Oden::Model::Item

=cut
