package Oden::Command::AYT;
use strict;
use warnings;

=head1 NAME

  Oden::Command::AYT - are you there.

=head1 DESCRIPTION

  Oden::Command::AYT is ping for Oden.

=cut

=head1 METHODS

=head2 run

  Its main talking method.

=cut

sub run {
    my $class = shift;
    my $hear  = shift;
    return unless $hear;
    return $hear =~ m{^([/!])?(A(?:re)*|R)(?:\s*)(Y(?:ou)*|U)(?:\s*)T(?:here)?(?:\?)?$}i ? '[yes]' : '';
}

1;

=head1 SEE ALSO

  Oden

=cut
