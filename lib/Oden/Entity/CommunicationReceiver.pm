use 5.40.0;
use experimental 'class';

class Oden::Entity::CommunicationReceiver {
    field $message  :param :reader;
    field $guild_id :param :reader;
    field $username :param :reader;
};

=head1 NAME

  Oden::Entity::CommunicationReceiver

=head1 DESCRIPTION

  Oden::Entity::CommunicationReceiver is a class designed to capture and process incoming data from Discord message_create event.

=head1 SYNOPSIS

  my $receiver = Oden::Entity::CommunicationReceiver->new(+{
    message => 'Are You There?',
    guild_id => 1234567890,
    username => 'yournick',
  };

=head1 Accessor

=over

=item B<message>

  This accessor represents a line of dialogue from a sender, which is used to generate a response.

=item B<guild_id>

  This accessor represents the unique identifier of the guild where the message was sent.

=item B<username>

  This accessor represents the username of the sender of the message.

=back

=cut
