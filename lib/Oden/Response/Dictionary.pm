package Oden::Response::Dictionary;
use 5.40.0;
use base 'Class::Accessor::Fast';

=head1 NAME

  Oden::Response::Dictionary

=head1 DESCRIPTION

  Oden::Response::Dictionary is response entity for dictionary.

=head1 SYNOPSIS

  my $response =  Oden::Response::Dictionary->new({ file_name=> xxxx });

=head1 Accessor

=over

=item B<filename>

  dictionary file name.

=item B<auto_remove>

  auto remove flag.
  this flag is true, remove file on DESTROY.

=back

=cut

__PACKAGE__->mk_accessors(qw/filename auto_remove/);

DESTROY {
    my $self = shift;
    unlink $self->filename if $self->auto_remove;
}
