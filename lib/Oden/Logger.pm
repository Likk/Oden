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

sub say {
    my ($self, $message) = @_;
    my $logger           = $self->{logger};

    my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) =
      localtime(time);
    my $time    = sprintf(
        "%04d-%02d-%02dT%02d:%02d:%02d",
        $year + 1900,
        $mon + 1, $mday, $hour, $min, $sec
    );

    my $full_message = sprintf("%s [SAY] %s",
        $time,
        $message,
    );
    $logger->print($full_message);
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

$Log::Minimal::PRINT = sub {
    my ( $time, $type, $message, $trace) = @_;
    return sprintf("%s [%s] %s at %s\n", $time, $type, $message, $trace);
};

1;
