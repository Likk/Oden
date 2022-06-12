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
    "token"                  => q{set your bot application's token},
    "information_channel_id" => q{set your guild general channel},
});

my $bot = AnyEvent::Discord->new({
    token   => $config->{token},
});

my $oden = Oden->new( token => $config->{token} );
my $discord =$oden->discord();

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

$bot->on('message_update', sub {
    my ($client, $data) = @_;

    # bot には反応しない
    return if $data->{author}->{bot};

    warn JSON::XS::encode_json($data);

    if( $data->{flags}                 &&
        $data->{flags} == 32           &&
        !defined $data->{member}       &&
        !defined $data->{author}->{id} &&
        !defined $data->{content}
    ){
        # スレッド情報が取れたら取る
        my $message      = $discord->show_message($data->{channel_id}, $data->{id});
        return unless $message->{thread}->{owner_id};

        # スレッドのあるチャンネルの情報が知りたい
        my $channel    = $discord->show_channel($message->{channel_id});

        ##チャンネル権限の設定がしてあったら閲覧者限定されてるので反応しない方がいい
        my $is_private = scalar @{ $channel->{permission_overwrites} };

        # スレッドは誰が作ったのか知りたい
        my $owner        = $discord->show_user($message->{thread}->{owner_id});
        return unless $owner->{username};

        my $res = sprintf("`%s` create thread `%s` in `%s` =>  https://discord.com/channels/%s/%s\n",
            # who, what, when.
            $owner->{username},
            $message->{thread}->{name},
            $client->channels->{$data->{channel_id}},

            # url
            $message->{thread}->{guild_id},
            $data->{id},
        );

        # 閲覧者限定チャンネルの場合投げないほうが良い気がしてきた
        my $post_channel_id =
          $is_private ? $data->{channel_id}
                      : $config->{information_channel_id};

        $client->send($post_channel_id, $res) if $res;
    }
});

$bot->connect();
AnyEvent->condvar->recv;
