package Oden::AnyEvent::Discord;
use strict;
use warnings;
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

    method _discord_identify() {
      $self->_debug('Sending identify');
      $self->_ws_send_payload(AnyEvent::Discord::Payload->from_hashref({
        op => 2,
        d  => {
          token           => $self->token,
          properties => {
            'os'      => 'linux',
            'browser' => $self->user_agent(),
            'device'  => $self->user_agent(),
          },

          compress        => JSON::false,
          large_threshold => 250,
          shard           => [0, 1],

          # TODO: enhance at an `Event::Discord#new` parameter.
          intents    => 1<<0|1<<1|1<<9|1<<11,
        }
      }));
    }

    method _lookup_gateway() {
      my $payload = $self->_discord_api('GET', 'gateway');
      die 'Invalid gateway returned by API' unless ($payload and $payload->{url} and $payload->{url} =~ /^wss/);

      # Add the requested version and encoding to the provided URL
      my $gateway = $payload->{url};
      $gateway .= '/' unless ($gateway =~/\/$/);
      $gateway .= '?v=9&encoding=json';
      return $gateway;
    }
};
use warnings;

1;
