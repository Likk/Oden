package Oden::Command::Dice;
use strict;
use warnings;
use utf8;
use 5.30.2;

use Games::Dice qw/roll roll_array/;
use List::Util  qw/sum/;

=head1 NAME

  Oden::Command::Dice - simulate dice rolls.

=head1 DESCRIPTION

  Oden::Command::Place is supported rolling dices for TRPG.

=cut

=head1 METHODS

=head2 run

  Its main talking method.

=cut

sub run {
    my $class = shift;
    my ($hear, $guild_id, $username) = @_;
    my $talk;

    # 
    unless($hear){
        my $dice = roll('1d6');
        my $emoji_list = [qw/0 1⃣ 2⃣ 3⃣ 4⃣ 5⃣ 6⃣/];
        $talk = $emoji_list->[$dice];
        return sprintf("(っ'-')╮=͟͟͞͞ﾌﾞｫﾝ ⌒Y⌒Y⌒Y⌒.   .  . . .. .... %s @%s", $talk, $username);
    }

    # lot rule.
    if($hear =~m{^loot$}){
        $talk = roll('1d99'); #1~99
        return sprintf("%s @%s", $talk, $username);
    }

    # TRPG lile
    ## 通常の使い方はこっち
    if($hear =~ m{^(\d+)?[Dd](\d+)?$}){
        my $unit  = $1 // 1; # default unit
        my $sided = $2 // 6; # default sided

        ## 異常系
        ### 投げて
        return sprintf("error! @%s", $username) if $unit  == 0;

        ### 何個投げても無駄
        return sprintf("0 @%s",      $username) if $sided == 0;

        ## 正常系
        my $roll_string = sprintf("%sD%s", $unit, $sided);

        ### one dice.
        return sprintf("%s @%s", roll($roll_string), $username) if $unit == 1;

        ### many dices.
        my @rolls = roll_array($roll_string);
        my $total = sum(@rolls);
        return sprintf("%s (%s) @%s",
            (
                $total == $unit * $sided ? 'CRITICAL!!' :
                $total == $unit          ? 'FUMBLE!!'  :
                                           'total: '. $total,
            ),
            join(',', @rolls),
            $username,
        );
    }
    ## FateDice (+0-)だけのやつ
    elsif($hear =~ m{^(\d+)?[Dd]F$}){
        my $unit  = $1 // 1; # default unit

        ## 異常系
        ### 投げて
        return sprintf("error! @%s", $username) if $unit  == 0;

        ## 正常系
        my $roll_string = sprintf("%sDF", $unit);
        my @rolls = map {
            $_ == -1 ? '-' :
                  0  ? '0' :
                  1  ? '+' :
                  '/'; #ここにはこないはず
        } roll_array($roll_string);

        return sprintf("%s %s",
            join(',', @rolls),
            $username
        );
    }

    return;
}

1;

=head1 SEE ALSO

  L<Oden>

=cut
