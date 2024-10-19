package Oden::Command::MarketBoard;
use 5.40.0;

use Function::Parameters;
use Function::Return;
use Number::Format;

use Oden::API::Universalis;
use Oden::Entity::CommunicationEmitter;
use Oden::Model::Item;

use Types::Standard -types;

use constant {
    "Oden::Entity::CommunicationReceiver" => InstanceOf['Oden::Entity::CommunicationReceiver'],
    "Oden::Entity::CommunicationEmitter"  => InstanceOf['Oden::Entity::CommunicationEmitter'],
};

=head1 NAME

  Oden::Command::Marketboard

=head1 DESCRIPTION

  Oden::Command::Marketboard

=head1 PACKAGE GLOBAL VARIABLES

=head2 PARSE_MARKET_PATTERN

  pattern for parsing market command.

=cut

our $PARSE_MARKET_PATTERN = qr{
    \A                       # start
    (?<target>.+?)           # target
    \s                       # space
    (?<hq_flag>HQ)?\s?       # HQ flag
    (?<item_name>.+)         # item name
    \z                       # end
}x;

=head1 METHODS

=head2 run

  Its main talking method.

=cut

fun run(ClassName $class, Oden::Entity::CommunicationReceiver $receiver) : Return(Oden::Entity::CommunicationEmitter) {
    my $hear   = $receiver->message || '';
    my $entity = Oden::Entity::CommunicationEmitter->new();

    my ($world_or_dc, $hq_flag, $item_name) = $class->parse_message($hear);
    return $entity unless $item_name;

    my $item = Oden::Model::Item->lookup_item_by_name($item_name);
    return $entity unless $item;
    return $entity unless $item->is_tradable;

    my $res = Oden::API::Universalis->current_data(+{
        world_or_dc => $world_or_dc,
        $hq_flag ? ( hq =>  1 ): (),
        item_ids    => [ $item->{id} ],
    });

    if($res){
        my $response = $class->format_response($res);
        $entity->message($response);
        return $entity;
    }

    $entity->message("Oops! Cannot read response. Retry at a later time");
    return $entity;
}

=head2 parse_message

  parse message and return target, hq_flag, item_name.

=cut

fun parse_message(ClassName $class, Str $hear) : Return(Maybe[Str],Maybe[Str],Maybe[Str]) {
    if ($hear =~ $PARSE_MARKET_PATTERN) {
        return (
          $+{target},
          $+{hq_flag} || '',
          $+{item_name}
      );
    }
    return (undef, undef, undef);
}


=head2 format_response

  format market board data.
  Server Name, Price, Quantity, HQ

=cut

fun format_response(ClassName $class, HashRef $res) : Return(Str) {
    my $records = $res->{records};
    my $header  = sprintf("last update: %s\n", $res->{lastUploadTime} || 'none');
    my $body    = '';

    # longest worldName
    my $max_length = [
        sort {
            $b <=> $a
        }
        map {
            length($_->{worldName}),
        } @$records
    ]->[0] +1;
    my $world_name_width = "%-${max_length}s";

    for my $row (@$records){
        $body .= sprintf ("`$world_name_width: Gil%11s x %3s`%s\n",
            $row->{worldName},
            Number::Format::format_price($row->{pricePerUnit}, 0, ''),
            $row->{quantity},
            $row->{hq} ? ' <:hq:983319334476742676>' : '',
        );
    }
    return sprintf("%s\n%s", $header, $body);
}

=head1 SEE ALSO

  Oden::API::Universalis

=cut
