package Oden::Model::Item;
use autodie;
use strict;
use warnings;
use utf8;
use 5.30.2;
use Encode;
use FindBin;

use JSON::XS qw/decode_json/;
use URI::Escape;

=head1 NAME

Oden::Model::Item - lookup item lodestone by name_ja.

=head1 DESCRIPTION

  Oden::Model::Item is provide URL of lodeston from item name.

=cut

# loading data on use.

our $DATA_DIR;
our $NAME_JA_TO_ITEM_ID;
our $ITEM_ID_TO_NAME;
our $NAME_TO_ITEM_ID;

sub import {
    my $class  = __PACKAGE__;
    my $caller = caller(0);

    $DATA_DIR            = './data';
    $NAME_JA_TO_ITEM_ID  = do sprintf("%s/name_ja_to_item_id.pl", $DATA_DIR)
      or die 'cant read name_ja_to_item_id';

    $ITEM_ID_TO_NAME     = decode_json($class->_read_json(sprintf("%s/items.json", $DATA_DIR)));

    for my $id (keys %$ITEM_ID_TO_NAME){
        my $value = $ITEM_ID_TO_NAME->{$id};
        for my $lang (keys %$value){
            $NAME_TO_ITEM_ID->{$value->{$lang}} = +{
                id   => $id,
                lang => $lang,
            };
        }
    }
}

=head1 CONSTRUCTOR AND STARTUP METHODS

=head2 new

  Creates and returns a Item Object

=cut

sub new {
    my ($class) = @_;

    my $self = bless {}, $class;
    return $self;
}

=head2 lookup_item_id_by_name_ja

  Creates and returns a Item object from name_ja

=cut

sub lookup_item_by_name {
    my ($invocant, $name) = @_;
    return unless $name;

    my $self = ref $invocant eq 'Oden::Model::Item'
      ? $invocant
      : $invocant->new;
    ;

    return unless $NAME_TO_ITEM_ID->{$name};

    $self->{name} = $name;
    $self->{id}   = $NAME_TO_ITEM_ID->{$name}->{id};
    $self->{lang} = $NAME_TO_ITEM_ID->{$name}->{lang};
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
    my $lang =
        $self->{lang} eq 'ja' ? 'jp'
      : $self->{lang} eq 'en' ? 'na'
      : $self->{lang}
    ;
    return sprintf("https://%s.finalfantasyxiv.com/lodestone/playguide/db/item/%s/", $lang, $lodestone_id);
}

=head2 miraprisnap_url

=cut

sub miraprisnap_url {
    my $self = shift;
    my $name_ja            = $ITEM_ID_TO_NAME->{$self->{id}}->{ja};
    my $uri_escape_name_ja = URI::Escape::uri_escape_utf8($name_ja);
    return sprintf("https://mirapri.com/?keyword=%s", $uri_escape_name_ja);
}


=head1 PRIVATE METHDOS

=head2 _read_json

XXX: Can't use JSON::Parse#read_json
```
  an undefined value as a subroutine reference at local/lib/perl5/AnyEvent/Discord.pm line 276.
```

=cut

sub _read_json {
    my ($self, $file) = @_;
    local $/; #Enable 'slurp' mode
    open my $fh, "<", $file;
    my $json = <$fh>;
    close $fh;
    return $json;
}

1;
