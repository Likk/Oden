package Oden::Command::ItemSearch;
use strict;
use warnings;
use 5.30.2;
use Encode;
use FindBin;
use URI::Escape;

=head1 NAME

  Oden::Command::ItemSearch - item search from loadstone.

=head1 DESCRIPTION

  Oden::Command::ItemSearch is provide URL of loadston from item name.

=cut

our $BASE_DIR           = "$FindBin::Bin/";
our $DATA_DIR           = "$BASE_DIR/data";
our $NAME_JA_TO_ITEM_ID = do "$DATA_DIR/name_ja_to_item_id.pl";

=head1 METHODS

=head2 run

  Its main talking method.

=cut

sub run {
    my $class = shift;
    my $hear  = shift;

    my $talk;
    if(my $item_id = $NAME_JA_TO_ITEM_ID->{Encode::encode_utf8($hear)}){
        my $lodestone_id = `awk 'NR==$item_id' $DATA_DIR/lodestone-item-id.txt`;
        chomp $lodestone_id;
        $talk = sprintf(<<"EOT", $lodestone_id, URI::Escape::uri_escape_utf8($hear));
loadstone:   https://jp.finalfantasyxiv.com/lodestone/playguide/db/item/%s/
miraprisnap: https://mirapri.com/?keyword=%s
EOT
    }

    return $talk;
}

1;

=head1 SEE ALSO

  Oden

=cut
