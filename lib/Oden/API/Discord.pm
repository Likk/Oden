package Oden::API::Discord;
use 5.40.0;
use feature qw/try/;

use Function::Parameters;
use Function::Return;
use Furl;
use HTTP::Request::Common;
use JSON::XS    qw/decode_json encode_json/;
use Time::HiRes qw/gettimeofday tv_interval/;
use Types::Standard -types;
use URI;

=head1 NAME

  Oden::API::Discord

=head1 DESCRIPTION

  Oden::API::Discord api client for discord

=cut

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  Creates and returns a new chat bot object

  Args:
    # Required
      token : Str
    # Optional
      base_url : Str # default: 'https://discordapp.com/api'
      interval : Int # default: 1
      last_req : ArrayRef # default: [epoch.msec]

=cut

method new($class: %args) :Return(InstanceOf[Oden::API::Discord]) {
    my $self = bless +{ %args }, $class;
    die 'require token parameter.' unless $self->{token};

    $self->{base_url} ||= 'https://discordapp.com/api';
    $self->{last_req} ||= $self->last_request_time;
    $self->{interval} //= 1;
    return $self;
}

=head1 METHODS

=head2 endpoint_config

  create named endpoint hash.

=cut

method endpoint_config() :Return(HashRef) {
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

  Returns a user object for a given user ID.

  GET `/users/{user.id}`

  Args:
    user_id : Int

  Returns:
    HashRef

=cut

method show_user(Int $user_id) :Return(Maybe[HashRef]) {
    my $res = $self->_request(
        sprintf($self->endpoint_config->{show_user}, $user_id) => +{}
    );
    return $res ? $res : undef;
}

=head2 show_channel

  Get a channel by ID. Returns a channel object.
  If the channel is a thread, a thread member object is included in the returned result.

  GET `/channels/{channel.id}`

  Args:
    channel_id : Int

  Returns:
    HashRef

=cut

method show_channel(Int $channel_id) :Return(Maybe[HashRef]) {
    my $res = $self->_request(
        sprintf($self->endpoint_config->{show_channel}, $channel_id) => +{}
    );
    return $res ? $res : undef;
}

=head2 list_guild_members

  Returns a list of guild member objects that are members of the guild.

  GET `/guilds/{guild.id}/members`

  Args:
    guild_id : Int
    option   : HashRef
      limit : Int (1-1000)

  Returns:
    ArrayRef[HashRef]

=cut

method list_guild_members(Int $guild_id, HashRef $option = {}) :Return(Maybe[ArrayRef]) {
    $option->{limit} ||= 50;
    my $res = $self->_request(
        sprintf($self->endpoint_config->{list_guild_members}, $guild_id) => $option
    );
    return $res ? $res : undef;
}

=head2 show_message

  Retrieves a specific message in the channel. Returns a message object on success,

  GET `/channels/{channel.id}/messages/{message.id}`


=cut

method show_message(Int $channel_id, Int $message_id) :Return(Maybe[HashRef]) {
    my $res = $self->_request(
        sprintf($self->endpoint_config->{show_message}, $channel_id, $message_id) => +{}
    );
    return $res ? $res : undef;
}

=head2 send_message

  request create message.

=cut

method send_message(Int $channel_id, Str $content) :Return(Maybe[Bool]) {

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
        return undef;
    }
    return 1;
}

=head2 send_attached_file

    request create message with attachement file,

=cut

method send_attached_file(Int $channel_id, Str $path, @args)  :Return(Maybe[Bool]) {
    # filename is optional, default is basename of path.
    my ($filename) = @args;
    $filename ||= [split('/', $path)]->[-1];

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

    $self->_sleep_interval;
    my $res = $self->_user_agent->request($req);
    unless($res->is_success()){
        warn $res->status_line;
        warn $res->message;
        return undef;
    }
    return 1;
}

=head2 join_thread

  put request thread-members @me

=cut

method join_thread(Int $channel_id) :Return(Maybe[Bool]) {
    my $endpoint = sprintf("%s/channels/%s/thread-members/%s",
        $self->{base_url},
        $channel_id,
        '@me',
    );

    my $req = HTTP::Request->new('PUT' => $endpoint,
        [
            Authorization => sprintf("Bot %s", $self->{token}),
            User_Agent    => $self->_user_agent->agent,
        ],
    );

    $self->_sleep_interval;
    my $res = $self->_user_agent->request($req);
    unless($res->is_success()){
        warn $res->status_line;
        warn $res->message;
        return undef;
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
    try {
        $data = decode_json($res->decoded_content());
    }
    catch($e){
        warn $e;
    };
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
    return 0 unless $self->{interval};

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
