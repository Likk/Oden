package Oden::Command::Dictionary;
use strict;
use warnings;

use Oden::Model::Dictionary;
use Oden::API::Universalis;

=head1 NAME

  Oden::Command::Dictionary

=head1 DESCRIPTION

  Oden::Command::Dictionary

=cut

=head1 METHODS

=head2 run

  Its main talking method.

=cut

sub run {
    my $class      = shift;
    my $hear       = shift;
    my $channel_id = shift;

    return unless $hear;

    my $talk;

    warn $hear;
    if($hear =~ m{(add|set|get|show)\s([^\s]+)(?:\s+)?(.*)?}){
        my $method = $1;
        my $key    = $2;
        my $value  = $3;

        my $dict = Oden::Model::Dictionary->new({ channel_id => $channel_id});
        if($method =~ m{(add|set)}){
            my $value = $hear;
            $value =~s{(add|set)\s$key\s*}{};
            my $res = $dict->set($key => $value);
            $talk .= 'registrated' if $res;
            $talk .= 'fail'        unless $res;
        }
        elsif($method =~m{get|show}){
            my $res = $dict->get($key);
            $talk .= $res              if     $res;
            $talk .= 'not registrated' unless $res;
        }

    }
    return $talk;
}

1;

=head1 SEE ALSO

  Oden

=cut
