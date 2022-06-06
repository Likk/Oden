package Oden::Command::Fishing;
use strict;
use warnings;
use 5.30.2;

use Oden::Model::Item;


=head1 NAME

  Oden::Command::Fishing - show fishing informatin on teamcraft.

=head1 DESCRIPTION

  Oden::Command::ItemSearch is provide URL of ffxivteamcraft from item name

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
    if(my $item = Oden::Model::Item->lookup_item_by_name($hear)){
        return unless $item->is_fishable;
        $talk .= sprintf("teamcraft: %s\n",   $item->ffxivteamcraft_url);
    }

    return $talk;
}

1;

=head1 SEE ALSO

  Oden

=cut
