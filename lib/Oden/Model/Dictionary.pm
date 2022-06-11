package Oden::Model::Dictionary;
use strict;
use warnings;
use utf8;
use autodie;
use Encode;
use Storable qw/nstore retrieve/;

=head1 NAME

Oden::Model::Dictionary

=head1 DESCRIPTION

  Oden::Model::Dictionary is key-word dictionary.

=head1 SINOPSYS

  my $dictionary =  Oden::Model::Dictionary->new({ file_name=> xxxx });
  $dictionary->set( foo => 'bar');
  print $dictionary->get('foo'); # bar

=head1 CAUTION

  This module has critical bug.
  dictionary file does not support file locking.
  I plan on dealing with it within a few days.

=head1 CONSTRUCTOR AND STARTUP METHODS

=head2 new

  Creates and returns a Item Object

=cut

sub new {
    my ($class, $opt) = @_;

    my $dic_dir = $ENV{DICT_DIR} || './dict';

    $opt            ||=+{};
    $opt->{dic_dir} ||= $dic_dir;

    die 'require file_name option. Oden::Model::Dictionary->new({ file_name => xxxx })'
      unless $opt->{file_name};

    my $self = bless $opt, $class;
    return $self;
}

=head2 METHODS

=head2  set

  set key-value data on dictionary.

=cut

sub set {
    my ($self, $key, $value) = @_;
    return unless $key;
    return unless $value;

    my $dictionary = $self->_dictionary;
    $dictionary->{$key} = $value;
    nstore($dictionary, $self->_file());
    return 1;
}

=head2 get

  get value from key on dictionary.

=cut

sub get {
    my ($self, $key) = @_;
    return unless $key;

    my $dictionary = $self->_dictionary;
    my $value = $dictionary->{$key};
    nstore($dictionary, $self->_file());
    return $value;
}

=head1 PRIVATE METHDOS

=head2 _dictionary

  create or find dictionaly

=cut

sub _dictionary {
    my ($self) = @_;
    my $dictionary;
    eval {
        my $file    = $self->_file;
        if(-s $file){
            $dictionary = retrieve($file);
        }
        else {
            $dictionary = +{};
        }
    };
    if($@){
        my $e = $@;
        if($e =~ m{No such file or directory}){
            $dictionary = +{};
        }
    }
    return $dictionary;
}

=head2 _file

  create or find dictionaly file

=cut

sub _file {
    my ($self) = @_;
    my $file = sprintf("%s/%s", $self->{dic_dir} , $self->{file_name});
    unless (-e $file){
        open my $fh, '>', $file;
        close $fh;
    }
    return $file;
}

1;
