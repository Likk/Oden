use strict;
use warnings;
use utf8;

use AnyEvent::Discord;
use Config::Pit qw/pit_get/;
use Encode;
use Oden;
use JSON::XS;

=head1 NAME

  bot.pl

=head1 SYNOPSIS

  ./env.sh perl bot.pl

=cut

my $config = pit_get("discord", require => {
    "token" => q{set your bot application's token},
});

my $bot = AnyEvent::Discord->new({
    token   => $config->{token},
});

my $oden = Oden->new();

$bot->on('message_create', sub {
    my ($client, $data) = @_;
    my $channel_id = $client->channels->{$data->{channel_id}};
    my $username   = $data->{author}->{username};
    my $content    = $data->{content};

    # bot には反応しない
    return if $data->{author}->{bot};

    warn JSON::XS::encode_json($data);

    my $res = $oden->talk($content, $data->{guild_id}, $username);
    $client->send($data->{channel_id}, $res) if $res
});

$bot->connect();
AnyEvent->condvar->recv;
