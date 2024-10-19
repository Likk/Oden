package Oden::Util::InteractionParser;

use strict;
use warnings;
use utf8;

=head1 NAME

  Oden::Util::InteractionParser

=head1 SYNOPSIS

  use Oden::Util::InteractionParser
  use Oden;
  my $interaction_parser  = Oden::Util::InteractionParser->new;
  my $message             = $interaction_parser->parse($data);
  my $res                 = Oden->tallk($content);

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  Creates and returns a new chat bot object

=cut

sub new {
    my ($class, %args) = @_;
    my $self = bless {%args}, $class;
    return $self;
}

=head1 METHODS

=cut

=head2 parse

  return structures list of all slash commands

=cut

sub parse {
    my ($self, $data) = @_;
    my $interaction_name = $data->{name} or return;

    unless ($self->can($name)){
        warn $name . ' command is not supported'.
        return;
    }

    $self->$name($data);
}

=head1 PRIVATE METHODS

=head2 command create

=over

=item B<_ayt>
=item B<_item_search>
=item B<_fishing>
=item B<_market>
=item B<_dict_file>
=item B<_dict_set>
=item B<_dict_overwrite>
=item B<_dict_get>
=item B<_dict_rename>
=item B<_dict_remove>
=item B<_place>
=item B<_dice>
=item B<_lot>

=cut

sub _ayt {
    return +{
        type => 1,
        name => 'ayt',
        description => 'It is like AYT commannd on telnet. AYT means "Are Your There?"',
        options => [],
        name_localizations => +{
            ja => '生きてますか',
        },
        description_localizations => +{
            ja => 'Bot が生きていれば [yes] と返してくれます。',
        },
    },

}

#sub _item_search {
#    return undef;
#}
#
#sub _fishing {
#    return undef;
#}
#
#sub _market {
#    return undef;
#}
#
#sub _dict_file {
#    return undef;
#}
#
#sub _dict_set {
#    return undef;
#}
#
#sub _dict_overwrite {
#    return undef;
#}
#
#sub _dict_get {
#    return undef;
#}
#
#sub _dict_rename {
#    return undef;
#}
#
#sub _dict_remove {
#    return undef;
#}
#
#sub _place {
#    return undef;
#}
#
#sub _dice {
#    return undef;
#}
#
#sub _lot {
#    return undef;
#}

=back

=cut
1;
