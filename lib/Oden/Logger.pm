package Oden::Logger;

use strict;
use warnings;
use utf8;

use JSON::XS;
use File::RotateLogs;
use Log::Minimal qw//;

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  Creates and returns a new chat bot object

=cut

sub new {
    my ($class, %args) = @_;
    my $self = bless {%args}, $class;
    $self->_create_logger();
    return $self;
}

sub _create_logger {
    my $self = shift;

    $self->{logger} ||= do {
        File::RotateLogs->new(
            logfile      => '/var/log/oden/bot/%Y/%m/%Y%m%d%H%M.log',
            linkname     => '/var/log/oden/bot/log',
            rotationtime => 3600,
            maxage       => 86400, #1day
        );
    };
}

{
    no strict 'refs';
    for my $method (qw/critf warnf infof  debugf critff warnff infoff debugff croakf croakff/){
        *{__PACKAGE__ . '::' . $method} = sub {
            my $self       = shift;
            my $logger     = $self->{logger};
            my $fullmethod = "Log::Minimal::$method";
            my $res = $fullmethod->(@_);
            $logger->print($res);
        };
    }
}

$Log::Minimal::PRINT = sub {
    my ( $time, $type, $message, $trace) = @_;
    return sprintf("%s [%s] %s at %s", $time, $type, $message, $trace);
};

1;
