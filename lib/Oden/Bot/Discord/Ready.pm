package Oden::Bot::Discord::Ready;
use 5.40.0;
use feature qw(try);

use Function::Parameters;
use Function::Return;

use Oden::Logger;
use Oden::Util::PlayList;

use Types::Standard -types;

use constant {
    "AnyEvent::Discord" => InstanceOf['AnyEvent::Discord'],
};

=encoding utf8

=head1 NAME

  Oden::Bot::Discord::Ready

=head1 DESCRIPTION

  Oden::Bot::Discord::Ready is a ready event handler of discord bot.
  this provides a function to update status of bot.


=head1 SYNOPSIS

  my $client = AnyEvent::Discord->new({
      token => $token,
  });
  $client->on('ready' => \&Oden::Bot::Discord::Ready::ready);

=head1 METHODS

=head2 ready

  request update status to discord api server.

=cut

fun ready(AnyEvent::Discord $client, HashRef $data, @args) :Return(Bool) {
    my $logger   = Oden::Logger->new;
    my $playlist = Oden::Util::PlayList->new;
    $logger->infof('Connected');
    my $playing = $playlist->pick;

    try {
        $client->update_status({
            since      => time,
            status     => 'online',
            afk        => 'false',
            activities => [{
                name => $playing,
                type => 0,
            }],
        });
        return 1;
    }
    catch ($e) {
        $logger->croakf('Failed to update status: %s', $e);
        return 0;
    };
}

=head1 SEE ALSO

L<Oden::Util::PlayList>

=cut
