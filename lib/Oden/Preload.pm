package Oden::Preload;
use 5.40.0;

use Oden::Model::Item; # load item data csv.

=encoding utf8

=head1 NAME

  Oden::Preload

=head1 DESCRIPTION

  Oden::Preload is a class designed to preload data.

=head1 SYNOPSIS

  use Oden::Preload;
  my item_id = Oden::Model::Item->lookup_item_by_name('item name');
