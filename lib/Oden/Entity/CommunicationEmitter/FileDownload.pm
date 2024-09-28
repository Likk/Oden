package Oden::Entity::CommunicationEmitter::FileDownload;
use 5.40.0;
use parent 'Oden::Entity::CommunicationEmitter';

=head1 NAME

  Oden::CommunicationEmitter::FileDownload

=head1 DESCRIPTION

  Oden::CCommunicationEmitter::FileDownload is response entity for file download.

=head1 SYNOPSIS

  my $entity = Oden::CommunicationEmitter::FileDownload->new(
    text => "xxxx",

  );
  $entity->>auto_remove(1);
  $response->file_path();

=head1 Accessor

=over

=item B<filename>

  dictionary file name.

=item B<auto_remove>

  auto remove flag.
  this flag is true, remove file on DESTROY.

=back

=cut

use Class::Accessor::Lite (
    new => 1,
    rw  => [qw/filename auto_remove/],
);

DESTROY {
    my $self = shift;
    unlink $self->filename if $self->auto_remove;
}
