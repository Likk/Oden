package Oden::Entity::CommunicationEmitter;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use Types::Standard -types;

=head1 NAME

  Oden::Entity::CommunicationEmitter

=head1 DESCRIPTION

  Oden::Entity::CommunicationEmitter is a class designed to  process outgoing data for content of Discord API.

=head1 SYNOPSIS

  my $receiver = Oden::Entity::CommunicationEmitter->new(+{
    message => 'Are You There?',
    username => 'yournick',
  };
  $receiver->as_content;

=head1 Accessor

=over

=item B<message>

  This accessor represents a line of dialogue from a sender, which is used to generate a response.

=item B<username>

  This accessor represents the username of the sender of the message.

=back

=cut

use Class::Accessor::Lite (
    new => 1,
    rw  => [qw/message username mention_flag/],
);

=head1 METHODS

=head1 as_content

  as_content method returns a string that represents the content of the message to be sent.

=cut

method as_content() :Return(Str) {
    return $self->mention_flag ? $self->as_content_with_mention : $self->message;
}

=head1 as_content_with_mention

  as_content_with_mention method returns a string that represents the content of the message to be sent with mention.

=cut

method as_content_with_mention() :Return(Str) {
    return sprintf("%s @%s", $self->message, $self->username);
}
