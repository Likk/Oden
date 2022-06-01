package Oden::Model::Item;
use strict;
use warnings;
use 5.30.2;
use Encode;
use FindBin;

#XXX: Can't use an undefined value as a subroutine reference at local/lib/perl5/AnyEvent/Discord.pm line 276.
# use JSON::Parse  qw/read_json/;

use JSON::XS /decode_json/;
use URI::Escape;

=head1 NAME

  Oden::Model::Item - lookup item lodestone by name_ja.

=head1 DESCRIPTION

  Oden::Model::Item is provide URL of lodeston from item name.

=cut

our $DATA_DIR;
our $NAME_JA_TO_ITEM_ID;
our $ITEM_ID_TO_NAME;

=head1 CONSTRUCTOR AND STARTUP METHODS

=head1 new

  Creates and returns a Item Object

=cut

sub new {
    my ($class) = @_;

    my $self = bless {}, $class;
    $self->_build;
    return $self;
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
    $self->{id}      = $NAME_JA_TO_ITEM_ID->{Encode::encode_utf8($name_ja)}
      or return;
    return $self;
}

=head1 GUESS ITEM NAME METHDOS

=head2 search_prefix_match_name_ja

=cut

# TODO: name_en, de, and fr.
#
sub search_prefix_match_name_ja {
    my ($self, $name_ja) = @_;
    return unless $name_ja;

    my $candidate = [grep {
        $_ =~ m/^$name_ja/;
    }
    map {
        $_->{ja}
    } values %$ITEM_ID_TO_NAME];

    return unless scalar @$candidate;
    return $candidate;
}

=head1 ITEM METHDOS

=head2 lodestone_url

=cut

sub lodestone_url {
    my $self = shift;
    my $data_dir = $DATA_DIR;

    # TODO: should not use awk.
    my $find_lodestone_item_id_command = sprintf("awk 'NR==%s' %s/%s", $self->{id}, $DATA_DIR, 'lodestone-item-id.txt');
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


=head1 PRIVATE METHDOS

=head2 _build

=cut

sub _build {
    my $self = shift;
    $DATA_DIR           = "./data";
    $NAME_JA_TO_ITEM_ID = do sprintf("%s/name_ja_to_item_id.pl", $DATA_DIR)
      or die 'cant read name_ja_to_item_id';
    $ITEM_ID_TO_NAME    = decode_json($self->_read_json(sprintf("%s/items.json", $DATA_DIR)));
}

sub _read_json {
    my ($self, $file) = @_;
    local $/; #Enable 'slurp' mode
    open my $fh, "<", $file;
    my $json = <$fh>;
    close $fh;
    return $json;
}
1;
