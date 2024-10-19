package Oden::Util::PlayList;
use 5.40.0;
use utf8;

use Function::Parameters;
use Function::Return;
use List::Util;
use Types::Standard -types;

=head1 NAME

  Oden::Util::PlayList

=head1 SYNOPSIS

  Oden::Util::PlayList->new->pick;


=head1 PACKAGE GLOBAL VARIABLES

=over

=item B<PROCESS>

  process list.

=cut

our $PROCESS = [qw/
    買い出し
    下ごしらえ
    下ゆで
    油抜き
    アク抜き
    出汁
    煮込み
    寝かせ
/];

=item B<INGREDIENTS>

  ingredients list.

=cut

our $INGREDIENTS = [qw/
    厚揚げ
    がんもどき
    牛すじ
    昆布
    ごぼ天
    蒟蒻
    さつま揚げ
    しらたき
    たこ
    大根
    卵
    竹輪
    ちくわぶ
    つくね
    つみれ
    はんぺん
    餅巾着
/];

=head1 CONSTRUCTOR AND STARTUP

=head2 new

  Creates and returns a new chat bot object

=cut

method new($class: %args) :Return(InstanceOf[Oden::Util::PlayList]) {
    my $self = bless {%args}, $class;
    return $self;
}

=head1 METHODS

=head2 pick

  pick up one from playlist.

=cut

method pick() :Return(Str) {
    $self->playlist;
    $self->_shuffle;
    return shift @{ $self->{_playlist} };
}

=head2 playlist

  set playlist.

  Args:
    (optional) ext_play_list: ArrayRef[Str]

  Returns:
    ArrayRef[Str]

=cut

method playlist(Maybe[ArrayRef[Str]] $ext_play_list = []) :Return(ArrayRef[Str]) {

    my $playlist = (ref $ext_play_list eq 'ARRAY' && scalar @$ext_play_list)
      ? $ext_play_list
      : [
          @$PROCESS,
          @$INGREDIENTS,
      ]
    ;
    if(!$self->{_playlist} || scalar @{$self->{_playlist}} == 0) {
        $self->{_playlist} = $playlist;
    }
    return $self->{_playlist};
}

=head1 PRIVATE METHODS

=head2 _shuffle

  shuffle playlist.

=cut

sub _shuffle {
     my $self = shift;
     $self->{_playlist} = [List::Util::shuffle @{ $self->playlist }];
}

1;
