package Oden::Command::Place;
use strict;
use warnings;
use 5.30.2;

=head1 NAME

  Oden::Command::Place - random choice DataCenter.

=head1 DESCRIPTION

  Oden::Command::Place is random sampling DataCenter's name.

=cut

=head1 METHODS

=head2 run

  Its main talking method.

=cut

sub run {
    my $class = shift;
    my $hear  = shift;
    my $talk;

    # 元GAIA民用。sampling gaia or meteor.
    unless($hear){
        $talk = List::Util::shuffle(qw/Gaia Meteor/);
        return $talk;
    }

    # 通常の使い方はこっち
    my $list = [split /[\s,]+/, $hear];
    $talk = List::Util::shuffle(@$list);

    return $talk;
}

1;

=head1 SEE ALSO

  L<Oden>

=cut
