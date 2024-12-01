package Oden;
use 5.40.0;

use Function::Parameters;
use Function::Return;

use Oden::Bot::Discord;

use Types::Standard -types;

=head1 NAME

  Oden

=head1 DESCRIPTION

  Oden is chat bot client for FFIXV community on discord.

=head1 SYNOPSIS

  use Oden;
  my $oden = Oden->new(token => 'your token');
  $oden->start();

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  Creates and returns a new chat bot object

=cut

method new(%args) :Return(InstanceOf['Oden']) {
    return bless {%args}, $self;
};

=head1 METHODS

=head2 start

  launch discord chat bot.

=cut

method start() {
    my $bot = Oden::Bot::Discord->new(
        token => $self->{token},
    );
    $bot->run();
}

=head1 LICENSE

Copyright (C) Likkradyus.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Likkradyus Winston. E<lt>perl {at} li {dot} que {dot} jpE<gt>

=cut
