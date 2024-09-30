package Oden::Command::Dictionary;
use 5.40.0;

use Function::Parameters;
use Function::Return;

use Oden::API::Universalis;
use Oden::Model::Dictionary;
use Oden::Entity::CommunicationEmitter;
use Oden::Entity::CommunicationEmitter::FileDownload;

use Types::Standard -types;

use constant {
    "Oden"                                => InstanceOf['Oden'],
    "Oden::Entity::CommunicationReceiver" => InstanceOf['Oden::Entity::CommunicationReceiver'],
    "Oden::Entity::CommunicationEmitter"  => InstanceOf['Oden::Entity::CommunicationEmitter'],
};

=head1 NAME

  Oden::Command::Dictionary

=head1 DESCRIPTION

  Oden::Command::Dictionary

=cut

=head1 METHODS

=head2 run

  Its main talking method.

=cut

fun run(ClassName $class, Oden::Entity::CommunicationReceiver $receiver) :Return(Maybe[Oden::Entity::CommunicationEmitter]) {
    my $hear     = $receiver->message;
    my $guild_id = $receiver->guild_id;
    return unless $hear;

    my $dict = Oden::Model::Dictionary->new({ file_name => $guild_id});

    if($hear =~ m{\Afile\z}){
        my $filename = $dict->create_tsv_file();
        my $entity = Oden::Entity::CommunicationEmitter::FileDownload->new(+{
            filename    => $filename,
        });
        return $entity;
    }

    my $entity = Oden::Entity::CommunicationEmitter->new;
    if($hear =~ m{\A(?:rename|move)\s+(.*)\s+(.*)}){
        my $before = $1;
        my $after  = $2;
        my $res = $dict->move($before, $after);
        $entity->message(
            $res ? sprintf("changed: %s => %s", $before, $after)
                 : sprintf("cant find %s", $before)
        );
    }
    elsif($hear =~ m{\A(?:get|show)\s+(.+)}){
        my $key    = $1;
        my $res = $dict->get($key);
        $entity->message(
            $res ? $res
                 : 'not registrated'
        );
    }
    elsif($hear =~ m{\A(?:add|set)\s([^\s]+)\s+}){
        my $key    = $1;
        my $value  = $hear;
        $value =~s{(add|set)\s+$key\s*}{};
        my $res = $dict->set($key => $value);
        $entity->message(
            $res ? 'registrated'
                 : 'the key already exists'
        );
    }
    elsif($hear =~ m{\A(?:overwrite)\s([^\s]+)\s+}){
        my $key    = $1;
        my $value  = $hear;
        $value =~s{(overwrite)\s+$key\s*}{};
        my $res = $dict->overwrite($key => $value);
        $entity->message(
            $res ? 'overwrote'
                 : 'not registrated'
        );
    }
    elsif($hear =~ m{\A(?:delete|remove)\s+(.+)}){
        my $key    = $1;
        my $res = $dict->remove($key);
        $entity->message(
            $res ? 'removed'
                 : 'not registrated'
        );
    }

    return $entity;
}

1;

=head1 SEE ALSO

  Oden

=cut
