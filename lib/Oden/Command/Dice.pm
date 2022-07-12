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
    if($hear =~ m{^(?:\d+)?d\d+$}){
        my @rolls = roll_array($hear);
        my $total = sum(@rolls);
        return sprintf("%s @%s", $total, $username) if scalar @rolls == 1;
        return sprintf("total:%s (%s) @%s",
            $total,
            join(',', @rolls),
            $username,
        );
    }
    elsif($hear =~ m{^(?:\d+)?dF$}){
        my @rolls = map {
            $_ == -1 ? '-' :
                  0  ? '0' :
                  1  ? '+' :
                  '/'; #ここにはこないはず
        } roll_array($hear);

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
