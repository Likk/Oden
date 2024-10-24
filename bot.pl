use strict;
use warnings;
use utf8;

use Config::Pit qw/pit_get/;
use Oden;

my $config = pit_get("discord", require => {
    "token"                  => q{set your bot application's token},
    "information_channel_id" => q{set your guild general channel},
});

my $oden    = Oden->new(
    %$config,
);

$oden->start;

__END__

=encoding utf8

=head1 NAME

  bot.pl

=head1 SYNOPSIS

  ./env.sh perl bot.pl

=cut

=head1 SEE ALSO

  L<Oden>

=cut
