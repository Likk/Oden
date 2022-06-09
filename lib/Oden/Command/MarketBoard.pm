package Oden::Command::MarketBoard;
use strict;
use warnings;
use 5.30.2;

use Oden::Model::Item;
use Oden::API::Universalis;

=head1 NAME

  Oden::Command::Marketboard

=head1 DESCRIPTION

  Oden::Command::Marketboard

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
    if($hear =~ m{(.*)?\s(.*)}){
        my $world_or_dc = $1;
        my $item_name   = $2;

        my $item = Oden::Model::Item->lookup_item_by_name($item_name);
        return $talk unless $item;

        return 'untradable' if(!$item->is_tradable);

        my $res = Oden::API::Universalis->current_data(+{
            world_or_dc => $world_or_dc,
            item_ids    => [ $item->{id} ],
        });

        $talk .= sprintf("last update: %s\n",   $res->{lastUploadTime});
        for my $row (@{$res->{entry}}){
            $talk .= sprintf("%s: price:%s, count:%s, %s\n",
                $row->{worldName},
                $row->{pricePerUnit},
                $row->{quantity},
                $row->{hq} ? '<:hq:983319334476742676>' : '',
            );
        }
    }
    return $talk;
}

1;

=head1 SEE ALSO

  Oden

=cut
