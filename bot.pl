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
    my $content    = $data->{content};

    # bot には反応しない
    return if $data->{author}->{bot};

    warn JSON::XS::encode_json($data);

    my $res = $oden->talk(
        $content,
        $data->{guild_id},
        $data->{author}->{username}
    );

    return unless($res);

    # Oden からのレスポンスによって返答の挙動を変えたい
    my $res_type = ref $res;

    if($res_type eq 'HASH' && $res->{filename}){ #今のところファイル添付しかないけど、ファイル型にした方良さそう # Oden::Response::File ... ?
        my $filename = $res->{filename};
        undef $res; # $fh 開放してあげないと、ロックかかってるっぽくて添付できない
        $discord->send_attached_file($data->{channel_id}, $filename, 'dictionary.tsv');

        # 基本的に不要なはず
        unlink $filename;
    }
    else { #型がなければ通常のテキスト返信
        $client->send($data->{channel_id}, $res) if $res
    }
});

$bot->on('message_update', sub {
    my ($client, $data) = @_;

    # bot には反応しない
    return if $data->{author}->{bot};
    # XXX: スレッド作成は message_update で送られてくる。
    #      既存メッセージの更新がないのに、メッセージ更新でおくられくるもの、かつ flags が 32 (= has_thread )をスレッド作成として扱う
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
