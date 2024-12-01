package Oden::Logger;
use 5.40.0;
use parent 'Class::Singleton';

use Carp qw/croak/;
use File::RotateLogs;
use Function::Parameters;
use Function::Return;
use Log::Minimal qw//;
use Types::Standard -types;

=head1 Construct and Start Singleton

=head2 new

  Creates and returns a new chat bot object

=cut

method new($class:) :Return(InstanceOf['Oden::Logger']) {
    my $self = $class->instance(@_);
    $self->_create_logger;
    return $self;
}

=head1 METHODS

=head2 say

  logging message.
  this method is ignore log level. always print message.

=cut

method say(Str $message) :Return(Str) {
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

=head2 critf

  logging CRITICAL message and die.

=head2 warnf

  logging WARNING message and warn.

=head2 infof

  logging INFO message.
  same as Log::Minimal::infof

=cut

method critf (Str $message) :Return() {
    $self->{logger}->print(Log::Minimal::critf($message));
    die $message;
}
method warnf (Str $message) :Return(Bool) {
    $self->{logger}->print(Log::Minimal::warnf($message));
    warn $message;
    return true;
}
method infof (Str $message) :Return(Bool) {
    $self->{logger}->print(Log::Minimal::infof($message));
    return true;
}

=head1 PRIVATE METHODS

=head2 _create_logger

  create logger object.

=cut

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

=head1 OVERWRITE

=head2 Log::Minimal::PRINT

  overwrite Log::Minimal::PRINT variable.
  this method is format log message.

=cut

$Log::Minimal::PRINT = sub {
    my ( $time, $type, $message, $trace) = @_;
    return sprintf("%s [%s] %s at %s\n", $time, $type, $message, $trace);
};


=head2 Log::Minimal::LOG_LEVEL

  overwrite Log::Minimal::LOG_LEVEL variable.
  this method is set log level.

=cut

$Log::Minimal::LOG_LEVEL = "INFO";

=head1 SEE ALSO

L<Log::Minimal>

=cut
