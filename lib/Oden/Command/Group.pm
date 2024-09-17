package Oden::Command::Group;
use strict;
use warnings;
use 5.30.2;

use List::Util;
use Text::Trim;

=head1 NAME

  Oden::Command::Group

=head1 DESCRIPTION

  Oden::Command::Group is supported random grouping generator.

=cut

=head1 METHODS

=head2 run

  Its main talking method.

=cut

sub run {
    my $class = shift;
    my $hear  = shift;
    my $talk;

    if($hear =~ m{^(?<number>\d+(?:\s+))?(?<names>.*)$}){
        my $number = Text::Trim::trim($+{number} || 2);
        my @names  = split /[\s,]+/, Text::Trim::trim($+{names} || '');
        return unless scalar @names;

        my $groups = $class->make_groups({
            size    => $number,
            members => \@names,
        });
        my $group_num = 1;
        for my $group (@$groups){
            $talk .= sprintf("Group %d: %s\n", $group_num , join ', ', @$group);
            $group_num++;
        }
        return $talk;
    }
}


=head2 make_groups


  make_groups is supported random grouping generator.

  Arguments:
    $number: Int
    $names: ArrayRef[Str]

  Returns: ArrayRef[Str]

=cut

sub make_groups {
    my ($class, $args) = @_;
    my $size    = $args->{size};
    my $members = $args->{members};

    # Validation
    ## $size is required, is Int and greater than 1
    return unless $size;
    return unless $size =~ m{^\d+$};

    ## $names is required, is ArrayRef and not empty.
    return unless $members;
    return unless ref $members eq 'ARRAY';
    return unless scalar @$members;

    my $groups = [map { [] } 1..$size];
    $members = [ List::Util::shuffle(@$members) ];
    for my $i (0..$#{$members}){
        push @{$groups->[$i % $size]}, $members->[$i];
    }
    return $groups;
}

1;

=head1 SEE ALSO

  L<Oden>

=cut
