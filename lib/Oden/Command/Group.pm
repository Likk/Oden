package Oden::Command::Group;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use List::Util;
use Oden::Entity::CommunicationEmitter;
use Types::Standard -types;

use constant {
    "Oden::Entity::CommunicationReceiver" => InstanceOf['Oden::Entity::CommunicationReceiver'],
    "Oden::Entity::CommunicationEmitter"  => InstanceOf['Oden::Entity::CommunicationEmitter'],
};

=head1 NAME

  Oden::Command::Group

=head1 DESCRIPTION

  Oden::Command::Group is supported random grouping generator.

=cut

=head1 METHODS

=head2 command_type

  Any of `active`, `fast_passive` and `passive`

=cut

fun command_type(ClassName $class) :Return(Str) {
    return 'active';
}

fun command_list(ClassName $class) :Return(ArrayRef[Str]) {
    return [qw/group/];
}

=head2 run

  Its main talking method.

=cut

fun run(ClassName $class, Oden::Entity::CommunicationReceiver $receiver) :Return(Maybe[Oden::Entity::CommunicationEmitter]) {
    my $hear   = $receiver->message;
    my $entity = Oden::Entity::CommunicationEmitter->new;

    if($hear =~ m{^(?<number>\d+(?:\s+))?(?<names>.+)$}){
        my $number =                 trim($+{number} || 2);
        my @names  = split /[\s,]+/, trim($+{names}  || '');

        return $entity unless $number;
        return $entity unless scalar @names;

        my $groups = $class->make_groups(
            size    => $number,
            members => \@names,
        );
        return $entity unless $groups;

        my $talk = '';
        my $group_num = 1;
        for my ($group_num, $group) (indexed @$groups){
            $talk .= sprintf("Group %d: %s\n", $group_num + 1 , join ', ', @$group);
        }
        chomp $talk;
        $entity->message($talk);
    }

    return $entity;
}


=head2 make_groups

  make_groups is supported random grouping generator.

  Arguments:
    $number: Int
    $names: ArrayRef[Str]

  Returns: ArrayRef[Str]

=cut

fun make_groups(ClassName $class, Int :$size, ArrayRef[Str] :$members) :Return(Maybe[ArrayRef[ArrayRef[Str]]]) {
    return undef unless scalar @$members;

    my $groups = [];
    $members = [ List::Util::shuffle(@$members) ];
    for my $i (0..$#{$members}){
        push @{$groups->[$i % $size]}, $members->[$i];
    }
    return $groups;
}
