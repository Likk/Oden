package Oden::Command::ItemSearch;
use strict;
use warnings;
use 5.30.2;

use Oden::Model::Item;


=head1 NAME

  Oden::Command::ItemSearch - item search from lodestone.

=head1 DESCRIPTION

  Oden::Command::ItemSearch is provide URL of lodeston from item name.

=cut

=head1 METHODS

=head2 run

  Its main talking method.

=cut

sub run {
    my $class = shift;
    my $hear  = shift;

    return unless $hear;
    my $talk;
    if(my $item = Oden::Model::Item->lookup_item_by_name_ja($hear)){
        my $lodestone_url   = $item->lodestone_url;
        my $miraprisnap_url = $item->miraprisnap_url;
        $talk .= sprintf("lodestone: %s\n",   $lodestone_url)   if $lodestone_url;
        $talk .= sprintf("miraprisnap: %s\n", $miraprisnap_url) if $miraprisnap_url;
    }
    return $talk;
}

1;

=head1 SEE ALSO

  Oden

=cut
