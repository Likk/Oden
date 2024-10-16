package Oden;
use 5.40.0;
use feature qw(try);
use utf8;

use Carp;
use Function::Parameters;
use Function::Return;

use Oden::API::Discord;
use Oden::Command::AYT;
use Oden::Entity::CommunicationReceiver;
use Oden::Dispatcher;
use Oden::Logger;
use Oden::Preload;
use Oden::Util::PlayList;

use Types::Standard -types;

#For Function::(Parameters|Return) InstanceOf
use constant {
    "Oden"                               => InstanceOf['Oden'],
    "Oden::API::Discord"                 => InstanceOf['Oden::API::Discord'],
    "Oden::Entity::CommunicationEmitter" => InstanceOf['Oden::Entity::CommunicationEmitter'],
    "Oden::Logger"                       => InstanceOf['Oden::Logger'],
    "Oden::Util::PlayList"               => InstanceOf['Oden::Util::PlayList'],
};

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

method new(%args) :Return(Oden) {
    return bless {%args}, $self;
};

=head1 METHODS

=head1 talk

=cut

method talk(Str $content, Int $guild_id, Str $username) :Return(Maybe[Str]|Oden::Entity::CommunicationEmitter) {
    return undef unless $content;

    # ping.
    if(my $res = Oden::Command::AYT->run($content)){
        return $res;
    }

    my ($command, $message);
    if($content =~ m{\A/(?<command>\w+)(?:\s+(?<message>.*))?\z}){
        $command = $+{command} || '';
        $message = $+{message} || '';
    }
    return undef unless $command;

    my $package = Oden::Dispatcher->dispatch($command);
    return undef unless $package;

    my $entity = Oden::Entity::CommunicationReceiver->new(
        message  => $message,
        guild_id => $guild_id,
        username => $username,
    );

    try {
        my $res = $package->run($message, $guild_id, $username);
        return $res;
    }
    catch ($e){
    };

    try {
        my $emitter =  $package->run($entity);
        return $emitter;
    }
    catch ($e){
        warn $e;
    };
}

=head1 Alias and instance chache methods

=head2 discord

  shortcut for Oden::API::Discord.

=cut

method discord() :Return(Oden::API::Discord) {
    return $self->{_discord} ||= Oden::API::Discord->new(
        token => $self->{token},
    );
}

=head2 logger

  shortcut for Oden::Logger.

=cut

method logger() :Return(Oden::Logger) {
    return $self->{_logger} ||= Oden::Logger->new();
}

=head2 playlist

  shortcut for Oden::Util::PlayList.

=cut

method playlist() :Return(Oden::Util::PlayList) {
    return $self->{_playlist} ||= Oden::Util::PlayList->new();
}
