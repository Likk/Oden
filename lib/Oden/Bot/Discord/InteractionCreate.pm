package Oden::Bot::Discord::InteractionCreate;
use 5.40.0;

use Function::Parameters;
use Function::Return;

use Oden::API::Discord;
use Types::Standard -types;

use constant {
    "AnyEvent::Discord" => InstanceOf['AnyEvent::Discord'],
};

=encoding utf8

=head1 NAME

  Oden::Bot::Discord::InteractionCreate

=head1 DESCRIPTION

  Oden::Bot::Discord::InteractionCreate is a interaction create event handler of discord bot.
  this provides a function to response "interaction create".

=head1 SYNOPSIS

  my $client = AnyEvent::Discord->new({
      token => $token,
  });
  $client->on('interaction_create' => \&Oden::Bot::Discord::InteractionCreate::interaction_create);

=head1 METHODS

=head2 interaction_create

  request callback interactions to discord api server.

=cut

method interaction_create(AnyEvent::Discord $client, HashRef $data, @args) :Return(Bool) {
    my $api = Oden::API::Discord->new( token => $client->token );

    my $interaction_id    = $data->{id};
    my $interaction_token = $data->{token};
    my $channel_id        = $data->{channel_id};

    my $callback_data = +{
        type => 4,
        data => +{ content => 'accept'},
    };
    $api->callback_interactions($interaction_id, $interaction_token, $callback_data);

    my $res = '//yes//';
    $client->send($channel_id, $res) if $res;

    return 1;
}

# $bot->on('interaction_create' => sub {
#     my ($client, $data) = @_;
#
#     warn YAML::Dump $client;
#     warn YAML::Dump $data;
#
#     my $interaction_id    = $data->{id};
#     my $interaction_token = $data->{token};
#     my $channel_id        = $data->{channel_id};
#
#     my $callback_data = +{
#         type => 4,
#         data => +{ content => 'accept'},
#     };
#     $discord->callback_interactions($interaction_id, $interaction_token, $callback_data);
#
#     my $res = '//yes//';
#     $client->send($channel_id, $res) if $res;
#
# });

=head1 SEE ALSO

  L<Oden::Bot>
  L<Oden::API::Discord>

=cut
