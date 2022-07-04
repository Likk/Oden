package Oden::AnyEvent::Discord;
use Moops;

class AnyEvent::Discord 0.7 {
    use v5.14;
    use AnyEvent::Discord::Payload;

    method update_status(HashRef $data,) {

        $data->{since }     ||= time;
        $data->{status}     ||= 'online';
        $data->{afk}        ||= 'false';
        $data->{activities} ||= [];

        $self->_ws_send_payload(AnyEvent::Discord::Payload->from_hashref({
          op => 3,
          d  => $data,
        }));

    }
};

1;
