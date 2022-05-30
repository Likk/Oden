use strict;
use warnings;
use JSON::XS qw/decode_json/;
use Data::Dumper;
use Encode;

=head1 NAME

  item_json_to_name_ja_to_item_id.pl

=head1 SYNOPSIS

  ./env.sh bin/item_json_to_name_ja_to_item_id.pl > data/name_ja_to_item_id.pl

=cut

my $json = read_json("data/items.json");
my $data = decode_json(read_json("items.json"));

my $output;
for my $key (keys %$data){
    my $name_ja = $data->{$key}->{ja};
    $output->{$name_ja} = $key;
}

my $name_ja_to_item_id = dumped($output);
print Encode::encode_utf8($name_ja_to_item_id);

sub dumped {
    my $input = shift;

    no warnings 'redefine';
    local *Data::Dumper::qquote =sub { return sprintf(qq{"%s"}, shift); };
    local $Data::Dumper::Useperl = 1;

    return Data::Dumper::Dumper($input);
}

sub read_json {
    my $file = shift;
    local $/; #Enable 'slurp' mode
    open my $fh, "<", $file;
    my $json = <$fh>;
    close $fh;
    return $json;
}
