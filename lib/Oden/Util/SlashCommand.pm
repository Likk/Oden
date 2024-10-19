package Oden::Util::SlashCommand;

use strict;
use warnings;
use utf8;

=encoding utf8

=head1 NAME

  Oden::Util::SlashCommand

=head1 SYNOPSIS

  use Oden::API::Discord;
  use Oden::Util::SlashCommand;

  my $command_list = Oden::Util::SlashCommand->new->command_list
  my $discord_api  = Oden::API::Discord->new;

  my $application_id = xxxxxx;
  my $guild_id       - xxxxxx;

  for my $command_data (@command_list){
      $discord_api->create_slash_command($application_id, $guild_id, $command_data);
  }

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  Creates and returns a new chat bot object

=cut

sub new {
    my ($class, %args) = @_;
    my $self = bless {%args}, $class;
    return $self;
}

=head1 METHODS

=cut

=head2 command_list

  return structures list of all slash commands

=cut

sub command_list {
    my $self = shift;
    my $command_list = [
        _ayt(),
        _item_search(),
        _fishing(),
        _market(),
#        _dict_file(),
#        _dict_set(),
#        _dict_overwrite(),
#        _dict_get(),
#        _dict_rename(),
#        _dict_remove(),
#        _place(),
#        _dice(),
#        _lot(),
    ];

    # 暫定的なフィルタ
    $command_list = [grep {
        $_
    } @$command_list];
    return $command_list;
}

=head1 PRIVATE METHODS

=head2 slash commands

=over

=item B<_ayt>
=item B<_item_search>
=item B<_fishing>
=item B<_market>
=item B<_dict_file>
=item B<_dict_set>
=item B<_dict_overwrite>
=item B<_dict_get>
=item B<_dict_rename>
=item B<_dict_remove>
=item B<_place>
=item B<_dice>
=item B<_lot>

=cut

sub _ayt {
    return +{
        type => 1,
        name => 'ayt',
        description => 'It is like AYT commannd on telnet. AYT means "Are Your There?"',
        options => [],
        name_localizations => +{
            ja => '生きてますか',
        },
        description_localizations => +{
            ja => 'Bot が生きていれば [yes] と返してくれます。',
        },
    },
}

sub _item_search {
    return +{
        type => 1,
        name => 'item_search',
        description => "lodestone (& `mirapurisnap`) URL associated for the item name. Forward match search if not found.",
        name_localizations => +{
            ja => 'アイテムサーチ',
        },
        description_localizations => +{
            ja => 'アイテム名に紐づく lodestone/mirapuri snap URLを提示します。見つからなければ前方一致検索します。',
        },
        options => [
            +{
                name        => "item_name",
                description => "The name of item",
                type        => 3,
                require     => 1,
                name_localizations => +{
                    ja => "アイテム名"
                },
                description_localizations => +{
                    ja => "検索したいアイテム名を入力してください"
                },
            },
        ],
    },
}

sub _fishing {
    return +{
        type => 1,
        name => 'fishing',
        description => "provide ffxivteamcraft URL.",
        name_localizations => +{
            ja => '釣り',
        },
        description_localizations => +{
            ja => 'いつ・どこで釣れるか分かるURLを提示します。',
        },
        options => [
            +{
                name        => "fish_name",
                description => "The name of fish",
                type        => 3,
                require     => 1,
                name_localizations => +{
                    ja => "アイテム名"
                },
                description_localizations => +{
                    ja => "釣る対象の名前を入力してください"
                },
            },
        ],
    },
}

sub _market {
    return +{
        type => 1,
        name => 'market',
        description => "Market Board aggregator",
        name_localizations => +{
            ja => 'マケボ',
        },
        description_localizations => +{
            ja => 'マケボの価格を表示します。情報が数時間前だったりするのはご愛嬌。',
        },
        options => [
            +{
                name        => "server_name",
                description => "input your server or DC name.",
                type        => 3,
                require     => 1,
                name_localizations => +{
                    ja => "サーバーまたはデータセンター名"
                },
                description_localizations => +{
                    ja => "サーバー名、またはDCを入力してください"
                },
            },
            +{
                name        => "item",
                description => "The name of item",
                type        => 3,
                require     => 1,
                name_localizations => +{
                    ja => "アイテム名"
                },
                description_localizations => +{
                    ja => "対象のアイテム名を入力してください"
                },
            },
        ],
    },

}

#sub _dict_file {
#    return undef;
#}
#
#sub _dict_set {
#    return undef;
#}
#
#sub _dict_overwrite {
#    return undef;
#}
#
#sub _dict_get {
#    return undef;
#}
#
#sub _dict_rename {
#    return undef;
#}
#
#sub _dict_remove {
#    return undef;
#}
#
#sub _place {
#    return undef;
#}
#
#sub _dice {
#    return undef;
#}
#
#sub _lot {
#    return undef;
#}

=back

=begin comment

/place
/choice
  - Gaia Meteor のどちらかをランダムで選ぶ
/place a b c d
/choice a b c d
  - a b c d のうちどれかひとつをランダムで選ぶ

/dice
  - 6面サイコロを振る
/dice loot
  - 1～99 をランダムで選ぶ
/dice 任意の数字d任意の数字
  - 任意の数字面のダイスを任意の数字個ぶん振る。2d6 なら 6面サイコロを2個振る

=end comment

=cut

1;
