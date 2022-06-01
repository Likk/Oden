package Oden::Model::Item;
use strict;
use warnings;
use 5.30.2;
use Encode;
use FindBin;
use URI::Escape;

=head1 NAME

  Oden::Model::Item - lookup item lodestone by name_ja.

=head1 DESCRIPTION

  Oden::Model::Item is provide URL of lodeston from item name.

=cut

=head1 CONSTRUCTOR AND STARTUP

=head1 new

  Creates and returns a Item Object

=cut

sub new {
    my ($class) = @_;

    my $self = bless {}, $class;
    $self->build;
    return $self;
}

sub build {
    my $self = shift;
    $self->{data_dir}           = "./data";
    $self->{name_ja_to_item_id} = do sprintf("%s/name_ja_to_item_id.pl", $self->{data_dir})
      or die 'cant read name_ja_to_item_id';
}

=head2 lookup_item_id_by_name_ja

  Creates and returns a Item object from name_ja

=cut

# TODO: name_en, de, and fr.
#
sub lookup_item_by_name_ja {
    my ($invocant, $name_ja) = @_;
    return unless $name_ja;

    my $self = ref $invocant eq 'Oden::Model::Item'
      ? $invocant
      : $invocant->new;
    ;

    # tentative ( encoded utf8 or flagged utf8, that is the question)
    $self->{name_ja} = $name_ja;
    $self->{id}      = $self->{name_ja_to_item_id}->{Encode::encode_utf8($name_ja)}
      or return;
    return $self;
}

=head1 METHDOS

=head2 lodestone_url

=cut

sub lodestone_url {
    my $self = shift;
    my $data_dir = $self->{data_dir};

    # TODO: should not use awk.
    my $find_lodestone_item_id_command = sprintf("awk 'NR==%s' %s/%s", $self->{id}, $self->{data_dir}, 'lodestone-item-id.txt');
    my $lodestone_id = `$find_lodestone_item_id_command`;
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
