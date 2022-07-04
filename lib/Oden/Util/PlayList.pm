package Oden::Util::PlayList;

use strict;
use warnings;
use utf8;
use feature    qw/say state/;
use List::Util;

=head1 NAME

  Oden::Util::PlayList

=head1 SYNOPSIS

  Oden::Util::PlayList->new->pick;

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

=cut

sub pick     {
    my $self = shift;
    $self->playlist();
    $self->shuffle;
    my ($pick) = shift @{ $self->{_playlist} };
    return $pick;
}

sub shuffle {
     my $self = shift;
     $self->{_playlist} = [List::Util::shuffle @{ $self->playlist }];
}

sub playlist {
    my ($self, $ext_play_list ) = @_;

    # process
    state $process = [qw/
        買い出し
        下ごしらえ
        下ゆで
        油抜き
        アク抜き
        出汁
        煮込み
    /];
    state $ingredients = [qw/
        冷却
        卵
        大根
        蒟蒻
        はんぺん
        卵
        餅巾着
        さつま揚げ
        しらたき
        つくね
        竹輪
        ちくわぶ
        がんもどき
        昆布
        厚揚げ
        ごぼう天
        牛すじ
    /];

    my $playlist = (ref $ext_play_list eq 'ARRAY' && scalar @$ext_play_list) ? $ext_play_list: [@$process, @$ingredients];
    $self->{_playlist} = $playlist unless $self->{_playlist};
    $self->{_playlist} = $playlist unless  scalar @{$self->{_playlist}};
    return $self->{_playlist};
}

1;
