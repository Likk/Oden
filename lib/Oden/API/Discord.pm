package Oden::API::Discord;
use strict;
use warnings;

use Furl;
use HTTP::Request::Common;
use JSON::XS    qw/decode_json encode_json/;
use Time::HiRes qw/gettimeofday tv_interval/;
use URI;

=head1 NAME

  Oden::API::Discord

=head1 DESCRIPTION

  Oden::API::Discord api client for discord

=cut

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  Creates and returns a new chat bot object

=cut

sub new {
    my ($class, %args) = @_;
    my $self = bless {%args}, $class;
    die 'require token parameter.' unless $self->{token};

    $self->{base_url} ||= 'https://discordapp.com/api';
    $self->{last_req} ||= $self->last_request_time;
    $self->{interval} ||= 1;
    return $self;
}

=head1 METHODS

=head2 endpoint_config

  create named endpoint list.

=cut

sub endpoint_config {
    my ($self) = @_;
    return $self->{endpoint_list} ||= do {
            +{
                show_message       => $self->{base_url} . "/channels/%s/messages/%s",
                show_channel       => $self->{base_url} . "/channels/%s",
                show_user          => $self->{base_url} . "/users/%s",
                list_guild_members => $self->{base_url} . "/guilds/%s/members",
            };
    };
}

=head2 show_user

  show user detail

=cut

sub show_user {
    my ($self, $user_id) = @_;

    return $self->_request(
        sprintf($self->endpoint_config->{show_user}, $user_id) => +{}
    );
}

=head2 show_channel

  show channel detail

=cut

sub show_channel {
    my ($self, $channel_id) = @_;

    return $self->_request(
        sprintf($self->endpoint_config->{show_channel}, $channel_id) => +{}
    );
}

=head2 list_guild_members

  show guild members list.

=cut

sub list_guild_members {
    my ($self, $guild_id, $option) = @_;
    $option->{limit} ||= 50;
    return $self->_request(
        sprintf($self->endpoint_config->{list_guild_members}, $guild_id) => $option
    );
}

=head2 show_message

  show message detail

=cut

sub show_message {
    my ($self, $channel_id, $message_id) = @_;

    return $self->_request(
        sprintf($self->endpoint_config->{show_message}, $channel_id, $message_id) => +{}
    );
}

=head2 send_message

  request create message.

=cut

sub send_message {
    my ($self, $channel_id, $content) = @_;

    my $endpoint = $self->{base_url} . sprintf("/channels/%s/messages", $channel_id);
    my $req = POST(
        $endpoint,
        Content_Type    => 'application/json',
        Authorization   => sprintf("Bot %s", $self->{token}),
        User_Agent      => $self->_user_agent->agent,
        Content         => encode_json(+{ content => $content }),
    );

    my $res = $self->_user_agent->request($req);
    unless($res->is_success()){
        warn $res->status;
        warn $res->message;
        return ;
    }
    return 1;

}

=head2 send_attached_file

    request create message with attachement file,

=cut

sub send_attached_file {
    my ($self, $channel_id, $path, $filename) = @_;
    $filename ||= $path;

    my $endpoint = $self->{base_url} . sprintf("/channels/%s/messages", $channel_id);
    my $req = POST(
        $endpoint,
        Content_Type    => 'multipart/form-data',
        Authorization   => sprintf("Bot %s", $self->{token}),
        User_Agent      => $self->_user_agent->agent,
        Content         => [
            file => [ $path => $filename]
        ],
    );

    my $res = $self->_user_agent->request($req);
    unless($res->is_success()){
        warn $res->status_line;
        return ;
    }
    return 1;
}

=head2 join_thread

  put request thread-members @me

=cut

sub join_thread {
    my ($self, $channel_id, ) = @_;

    my $endpoint = sprintf("%s/channels/%s/thread-members/%s",
        $self->{base_url},
        $channel_id,
        '@me',
    );

    $self->_sleep_interval;
    my $url = URI->new($endpoint);
    $url->query_form();
    my $req = HTTP::Request->new('PUT' => $endpoint,
        [
            Authorization => sprintf("Bot %s", $self->{token}),
            User_Agent    => $self->_user_agent->agent,
        ],
    );

    my $res = $self->_user_agent->request($req);

    my $data = {};

    unless($res->is_success()){
        warn $res->status_line;
        return ;
    }

    #returns no contents 204 responce
    return 1;
}


=head1 PRIVATE METHODS

=head2 _request

  request and response interface.

=cut

sub _request {
    my ($self, $endpoint, $params) = @_;

    $self->_sleep_interval;
    my $url = URI->new($endpoint);
    $url->query_form(%$params);
    my $req = HTTP::Request->new('GET' => $url->as_string,
        [
            Authorization => sprintf("Bot %s", $self->{token}),
            User_Agent    => $self->_user_agent->agent,
        ],
    );

    my $res = $self->_user_agent->request($req);

    my $data = {};
    unless($res->is_success()){
        warn $res->status;
        warn $res->message;
        return ;
    }
    eval {
        $data = decode_json($res->decoded_content());
    };
    if($@){
        my $e = $@;
        warn $e;
    }
    return $data;
}

=head2 _user_agent

  create furl object and return.

=cut

sub _user_agent {
    my $self = shift;
    my $furl = Furl->new(
        agent   => 'Oden bot client github.com/Likk/Oden',
        timeout => 10,
    );
    return $furl;
}

=head2 B<_sleep_interval>

  keep the Request interval.

=cut

sub _sleep_interval {
  my $self = shift;

  my $interval = tv_interval($self->last_request_time);
  my $wait = $self->{interval} - $interval;
  Time::HiRes::sleep($wait) if $wait > 0;
  $self->{last_req} = [gettimeofday];
}

=head2 B<last_request_time>

  request time at last request.

=cut

sub last_request_time { return shift->{last_req} ||= [gettimeofday] }

=head1 SEE ALSO

L<https://discord.com/developers/docs/intro>

=cut

1;
