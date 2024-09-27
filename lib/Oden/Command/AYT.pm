package Oden::Command::AYT;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use Types::Standard -types;

=head1 NAME

  Oden::Command::AYT - are you there.

=head1 DESCRIPTION

  Oden::Command::AYT is ping for Oden.

=cut

=head1 METHODS

=head2 run

  Its main talking method.
  If you say 'Are You There?' to Oden, Oden will respond with '[yes]'.

=cut

fun run(ClassName $class, Str $content = return undef) :Return(Maybe[Str]) {
    return unless $content;
    return $content =~ m{^([/!])?(A(?:re)*|R)(?:\s*)(Y(?:ou)*|U)(?:\s*)T(?:here)?(?:\?)?$}i ? '[yes]' : '';
}

=head1 SEE ALSO

  Oden

=cut
