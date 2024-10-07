package Oden::Command::Dice;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use Games::Dice qw/roll roll_array/;
use List::Util  qw/sum/;
use Oden::Entity::CommunicationEmitter;
use Text::Trim;
use Types::Standard -types;

use constant {
    "Oden::Entity::CommunicationReceiver" => InstanceOf['Oden::Entity::CommunicationReceiver'],
    "Oden::Entity::CommunicationEmitter"  => InstanceOf['Oden::Entity::CommunicationEmitter'],
};

=head1 NAME

  Oden::Command::Dice - simulate dice rolls.

=head1 DESCRIPTION

  Oden::Command::Place is supported rolling dices for TRPG.

=head1 SYNOPSIS

  use Oden::Command::Dice;
  use Oden::Entity::CommunicationReceiver;
  my $receiver = Oden::Entity::CommunicationReceiver->new(+{
      message  => '2d6',
      guild_id => 1,
      username => 'oden',
  });

  my $dice = Oden::Command::Dice->new();
  my $res  = $dice->run($receiver);

  # output random integer range 2 to 12
  print $res->message; # 7 @oden

=head1 PACKAGE GLOBAL VARIABLES

=head2 PARSE_ROLL_PATTERN

  pattern for parse like trpg dice roll.

=cut

our $PARSE_ROLL_PATTERN = qr{
    \A                       # start
    (
      (?<unit>\d+)?        # unit
      [Dd]                 # dice
      (?<sided>[
        \d                 # digitDice
        Ff                 # Fate (Fudge) Dice
      ]+)
    )
    (?:                    # option
      (?<sign>[
        \-+*/xX            # four arithmetic operations
        bB                 # best of dice
      ])
      (?<offset>\d+)
    )?
    \s*
    \z                       # end
}x;

=head1 METHODS

=head2 run

  Its main talking method.

=cut

fun run(ClassName $class, Oden::Entity::CommunicationReceiver $receiver) :Return(Maybe[Oden::Entity::CommunicationEmitter]) {
    my $hear   = Text::Trim::trim($receiver->message || '');
    my $entity = Oden::Entity::CommunicationEmitter->new(
        username => $receiver->username,
    );

    unless($hear){
        my $dice = roll('1d6');
        my $emoji_list = [qw/0 1⃣ 2⃣ 3⃣ 4⃣ 5⃣ 6⃣/];
        $entity->message(sprintf("(っ'-')╮=͟͟͞͞ﾌﾞｫﾝ ⌒Y⌒Y⌒Y⌒.   .  . . .. .... %s",
            $emoji_list->[$dice],
        ));
    }

    # lot rule.
    if($hear =~m{^loot$}){
        $entity->message(sprintf("%s", roll('1d99')));
    }

    # TRPG lile
    ## 通常の使い方はこっち
    if($hear =~ $PARSE_ROLL_PATTERN){
        $entity->message(sprintf("%s",
            $class->roll_trpg($hear),
        ));
    }
    $entity->add_mention if !$entity->is_empty;
    return $entity;
}

=head2 roll_trpg

  roll_trpg is supported rolling dices for TRPG.

=cut

fun roll_trpg(ClassName $class, Str $roll_string) :Return(Str) {
    if($roll_string =~ $PARSE_ROLL_PATTERN){
        my $unit  = $+{unit}  // 1; # default unit
        my $sided = $+{sided} // 6; # default sided
        my $sign  = $+{sign}  // '';
        my $offset= $+{offset} // 0;

        # 異常系
        ## 投げて
        return "error!"  if $unit  == 0;
        ## 何個投げても無駄
        return "0"       if $sided =~ m{\A0\z};

        # 正常系
        ## one dice.
        if($unit == 1){
            ### FateDice
            if($sided eq "F"){
                # delete sign and offset
                return $class->replace_fate_dice(roll("1dF"));
            }

            ### digit dice
            my $dice = roll($roll_string);
            return $dice;
        }

        ## many dices.
        my @rolls = roll_array($roll_string);

        ### FateDice
        if($sided eq "F"){
            @rolls = map { $class->replace_fate_dice($_) } @rolls;
            return join(',', @rolls);
        }

        ### normal digit dice
        my $total = sum(@rolls);

        #### best of dice
        if(uc($sign) eq 'B' && $offset > 0){
            @rolls = sort { $b <=> $a } @rolls;
            $total = sum(@rolls[0 .. $offset - 1]);
        }

        #### sign and offset
        my $op_total = 0;
        if($sign eq '+'){
            $op_total = $total + $offset;
        }
        if($sign eq '-'){
            $op_total = $total - $offset;
        }
        if($sign eq '*' || uc($sign) eq 'X'){
            $op_total = $total * $offset;
        }
        if($sign eq '/' && $offset != 0){
            $op_total = int($total / $offset);
        }

        return sprintf("%stotal:%s (%s)" => (
            ( #special case
                $total == $unit * $sided ? 'CRITICAL!! ' :
                $total == $unit          ? 'FUMBLE!! '   :
                ''
            ),
            $op_total ? $op_total : $total,
            join(' ', @rolls),
        ));
    }
    return '';
}

=head1 PRIVATE METHODS

=head2 _replace_fate_dice

  replace_fate_dice is supported rolling dices for FateDice.

=cut

fun replace_fate_dice(ClassName $class, Str $fate) :Return(Str) {
    return $fate == -1 ? '-' :
           $fate ==  0 ? '0' :
           $fate ==  1 ? '+' :
                    '/'; #ここにはこないはず
}

=head1 SEE ALSO

  L<Games::Dice>

=cut
