package Oden::Command::MarketBoard;
use strict;
use warnings;
use 5.30.2;

use Oden::Model::Item;
use Oden::API::Universalis;
use Number::Format;

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
    if($hear =~ m{(?<target>.+?)\s(?<hq_flag>HQ\s)?(?<item_name>.+)}){
        my $world_or_dc = $+{target};
        my $hq_flag     = $+{hq_flag} || '';
        my $item_name   = $+{item_name};
        my $item = Oden::Model::Item->lookup_item_by_name($item_name);
        return $talk unless $item;

        return 'untradable' if(!$item->is_tradable);

        my $res = Oden::API::Universalis->current_data(+{
            world_or_dc => $world_or_dc,
            $hq_flag ? ( hq =>  1 ): (),
            item_ids    => [ $item->{id} ],
        });

        if($res){
            $talk .= sprintf("last update: %s\n",   $res->{lastUploadTime});
            for my $row (@{$res->{entry}}){
                $talk .= $class->_format($row, $world_or_dc);
            }
        }
        else {
            $talk .= "Oops! Cannot read response. Retry at a later time";
        }
    }
    return $talk;
}

sub _format {
    my ($class, $row, $world) = @_;
    return sprintf ("`%-10s: Gil%11s x %3s`%s\n",
        $row->{worldName} || $world,
        Number::Format::format_price($row->{pricePerUnit}, 0, ''),
        $row->{quantity},
        $row->{hq} ? '<:hq:983319334476742676>' : '',
    );
}

1;

=head1 SEE ALSO

  Oden

=cut
