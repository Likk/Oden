package Oden::Model::Item;
use 5.40.0;
use autodie;

use Function::Parameters;
use Function::Return;

use Fcntl    qw/O_RDONLY/;
use FindBin;
use JSON::XS qw/decode_json/;
use Text::CSV;
use Tie::File;
use Types::Standard -types;
use URI::Escape;

=head1 NAME

  Oden::Model::Item - lookup item lodestone url.

=head1 DESCRIPTION

  Oden::Model::Item is provide URL of lodeston from item name.

=cut

=head2 PACKAGE VARIABLES

=over

=item B<$DATA_DIR>

  data directory path.

=item B<$ITEM_ID_TO_NAME>

  hashref of item id to name.
    id => { lang => name }

=item B<$NAME_TO_ITEM_ID>

  hashref of name to item id.
    name => { id => id, lang => lang }

=item B<$ITEM_DATA>

  data object of item.
    id => { key => value }

=back

=cut

our $DATA_DIR;
our $ITEM_ID_TO_NAME;
our $NAME_TO_ITEM_ID;
our $ITEM_DATA;

sub import {
    my $class  = __PACKAGE__;
    my $caller = caller(0);

    $DATA_DIR            = $ENV{DATA_DIR} || './data';
    $ITEM_ID_TO_NAME     = decode_json($class->_read_json(sprintf("%s/items.json", $DATA_DIR)));

    unless (scalar keys %$NAME_TO_ITEM_ID){
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
    unless (scalar keys %$ITEM_DATA ){
        my $csv       = Text::CSV->new (+{ binary => 1, sep_char => ",",});
        my $file_path = sprintf("%s/%s", $DATA_DIR, 'Item.csv');
        my $index     = 1;
        my $header    = [];
        open (my $fh, '<', $file_path);
        while(my $row = $csv->getline($fh)){
            next if $index == 1;
            next if $index == 3;
            next if $index == 4;

            $header     = $row if $index == 2;

            my $data;
            foreach my $column_number (0 .. $#{$header}){
                my $key = $header->[$column_number] || $column_number;
                $data->{$key} = $row->[$column_number];
            }
            $ITEM_DATA->{$data->{'#'}} = $data;
        }
        continue {
            $index++;
        }

        close $fh;
    }
}

=head1 CONSTRUCTOR AND STARTUP METHODS

=head2 new

  Creates and returns a Item Object

=cut

method new($class:) :Return(InstanceOf['Oden::Model::Item']) {
    return bless {}, $class;
}

=head2 lookup_item_by_name

  Creates and returns a Item object from name

=cut

method lookup_item_by_name(Str $name) :Return(Maybe[InstanceOf['Oden::Model::Item']]){
    $self = $self->new if(ref($self) ne 'Oden::Model::Item');
    return undef unless $name;
    return undef unless $NAME_TO_ITEM_ID->{$name};

    $self->{name} = $name;
    $self->{id}   = $NAME_TO_ITEM_ID->{$name}->{id};
    $self->{lang} = $NAME_TO_ITEM_ID->{$name}->{lang};
    $self->_item_data();
    return $self;
}

=head2 lookup_item_by_id

  Creates and returns a Item object from item id

=cut

method lookup_item_by_id(Int $id) :Return(Maybe[InstanceOf['Oden::Model::Item']]){
    $self = $self->new if(ref($self) ne 'Oden::Model::Item');
    return undef unless $id;
    return undef unless $ITEM_ID_TO_NAME->{$id};

    $self->{name} = $ITEM_ID_TO_NAME->{$id}->{en};
    $self->{id}   = $id;
    $self->{lang} = 'en';
    $self->_item_data();
    return $self;
}

=head1 GUESS ITEM NAME METHODS

=head2 search_prefix_match_name

  return prefix match item name list.

=cut

method search_prefix_match_name(Str $name) :Return(Maybe[ArrayRef[Str]]){
    return undef unless $name;

    my $candidate;
    for my $lang (qw/ja en fr de/){
        $candidate = [grep {
            $_ =~ m/^$name/;
        }
        map {
            $_->{$lang}
        } values %$ITEM_ID_TO_NAME];
        last if scalar @$candidate;
    }
    return undef unless scalar @$candidate;
    return $candidate;
}

=head1 ITEM METHODS

=head2 lodestone_url

  provide lodestone url from item.

=cut

method lodestone_url() :Return(Maybe[Str]){
    my $lodestone_id = $self->_item_hash_id;
    chomp $lodestone_id;
    return undef unless $lodestone_id;

    my $lang =
        $self->{lang} eq 'ja' ? 'jp'
      : $self->{lang} eq 'en' ? 'na'
      : $self->{lang}
    ;
    return sprintf("https://%s.finalfantasyxiv.com/lodestone/playguide/db/item/%s/", $lang, $lodestone_id);
}

=head2 ffxivteamcraft_url

  provide ffxivteamcraft url from item.

=cut

method ffxivteamcraft_url() :Return(Maybe[Str]){
    return sprintf("https://ffxivteamcraft.com/db/%s/item/%s/", $self->{lang}, $self->{id});
}

=head2 miraprisnap_url

  provide miraprisnap url from item.

=cut

method miraprisnap_url() :Return(Maybe[Str]){
    return undef unless $self->is_equipment;

    my $name_ja            = $ITEM_ID_TO_NAME->{$self->{id}}->{ja};
    my $uri_escape_name_ja = URI::Escape::uri_escape_utf8($name_ja);
    return sprintf("https://mirapri.com/?keyword=%s", $uri_escape_name_ja);
}

=head2 is_equipment

  It item is equipment any job, class.
  SEE ALSO: ffxiv.pf-n.co/xivapi?url=%2FEquipSlotCategory

=cut

method is_equipment() :Return(Bool){
    my $equip_slot_categorys = [
    # MainHand, OffHand, Head,  Body,   Gloves, Waist,  Legs,   Feet,   Ears,   Neck,   Wrists, Finger[LR], SoulCrystal
      1,        2,       3,     4,      5,      6,      7,      8,      9,      10,     11,     12,         17,
    # Any Combined equipment
    13..16, 18..21
    ];
    my $is_equipment = scalar grep {
        $self->{EquipSlotCategory} == $_;
    } @$equip_slot_categorys;
    return $is_equipment;
}

=head2 is_fishable

  return true if It item can be caught(hooking/giging).

=cut

method is_fishable() :Return(Bool){
    return $self->{ItemUICategory} == 47 ? true : false;
}

=head2 is_tradable

  return true if It item can be traded.

=cut

method is_tradable() :Return(Bool){
    return ($self->{IsUntradable} eq 'False') ? true : false;
}


=head1 PRIVATE METHODS

=head2 _item_hash_id

  id to lodestone hash id

=cut

sub _item_hash_id {
    my $self = shift;
    my $file_path = sprintf("%s/%s", $DATA_DIR, 'lodestone-item-id.txt');
    open (my $fh, '<', $file_path);
    tie my @rows, 'Tie::File', $fh, mode => O_RDONLY, autochomp => 1;
    my $hash_id = $rows[$self->{id} - 1]; #array start 0 but file line start 1
    return $hash_id;
}

=head2 _item_data

  item's detail data.

=cut

sub _item_data {
    my $self = shift;

    my $item_data = $ITEM_DATA->{$self->{id}};
    for my $key(keys %$item_data){
        $self->{$key} = $item_data->{$key};
    }
}

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
