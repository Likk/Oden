package Oden;
use strict;
use warnings;
use utf8;

use Encode qw/encode_utf8/;
use FindBin;
use URI::Escape;

use Oden::API::Discord;
use Oden::Command::AYT;
use Oden::Dispatcher;
use Oden::Logger;
use Oden::Preload;
use Oden::Util::PlayList;

=head1 NAME

  Oden

=head1 DESCRIPTION

  Oden is chat bot client for FFIXV community on discord.


=head1 SYNOPSIS

  use Oden;
  my $oden = Oden->new();
  my $res  = $oden->talk('Are Your There?');
  print $res; #[yes]

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

=head1 talk

=cut

sub talk {
    my ($self, $content, $guild_id, $username) = @_;

    my $res;

    # ping.
    if($res = Oden::Command::AYT->run($content)){
        return $res;
    }

    if($content =~ m{\A/(\w+)\z}){
        my $command = $1;
        my $package = Oden::Dispatcher->dispatch($command) or return;
        $res = $package->run('', $guild_id, $username);
    }
    elsif($content =~ m{^/(\w+)?\s+(.*)}){
        my $command = $1;
        my $message = $content;
        $message =~ s{/$1\s}{};
        my $package = Oden::Dispatcher->dispatch($command) or return;
        $res = $package->run($message, $guild_id, $username);
    }
    return $res;
}

sub discord {
    my $self = shift;
    return $self->{_discord} ||= do {
        Oden::API::Discord->new(
            token => $self->{token},
        );
    };
}

sub playlist {
    my $self = shift;
    return $self->{_playlist} ||= do {
        Oden::Util::PlayList->new();
    }
}

sub logger {
    my $self = shift;
    return $self->{_logger} ||= do {
        Oden::Logger->new();
    }

}
1;
