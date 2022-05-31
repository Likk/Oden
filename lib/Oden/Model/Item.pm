package Oden::Model::Item;
use strict;
use warnings;
use 5.30.2;
use Encode;
use FindBin;
use URI::Escape;

=head1 NAME

  Oden::Model::Item - lookup item loadstone by name_ja.

=head1 DESCRIPTION

  Oden::Model::Item is provide URL of loadston from item name.

=cut

=head1 CONSTRUCTOR AND STARTUP

=head2 lookup_item_id_by_name_ja

  Creates and returns a Item object.

=cut

# TODO: name_en, de, and fr.
sub lookup_item_by_name_ja {
    my ($class, $name_ja) = @_;

    return unless $name_ja;
    my $self = bless {}, $class;
    $self->build;

    # tentative ( encoded utf8 or flagged utf8, that is the question)
    $self->{name_ja} = $name_ja;
    $self->{id}      = $self->{name_ja_to_item_id}->{Encode::encode_utf8($name_ja)}
      or return;
    return $self;
}

sub build {
    my $self = shift;
    $self->{base_dir}           = "$FindBin::Bin/";
    $self->{data_dir}           = sprintf("%s/data", $self->{base_dir} );
    $self->{name_ja_to_item_id} = do sprintf("%s/name_ja_to_item_id.pl", $self->{data_dir});
}

=head1 METHDOS

=head2 lodestone_url

=cut

sub lodestone_url {
    my $self = shift;
    my $data_dir = $self->{data_dir};
    # TODO: should not use awk.

    my $find_loadstone_item_id_command = sprintf("awk 'NR==%s' %s/%s", $self->{id}, $self->{data_dir}, 'lodestone-item-id.txt');
    my $lodestone_id = `$find_loadstone_item_id_command`;
    chomp $lodestone_id;
    return unless $lodestone_id;
    return sprintf("https://jp.finalfantasyxiv.com/lodestone/playguide/db/item/%s/", $lodestone_id);
}

=head2 miraprisnap_url

=cut

sub miraprisnap_url {
    my $self = shift;
    my $uri_escape_name_ja = URI::Escape::uri_escape_utf8($self->{name_ja});
    return sprintf("https://mirapri.com/?keyword=%s", $uri_escape_name_ja);
}

1;
