package Oden::Command::Dictionary;
use strict;
use warnings;

use Oden::API::Universalis;
use Oden::Model::Dictionary;
use Oden::Response::Dictionary;

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
    my $guild_id = shift;

    return unless $hear;

    my $talk;

    my $dict = Oden::Model::Dictionary->new({ file_name => $guild_id});

    if($hear =~ m{\Afile\z}){
        my $filename = $dict->create_stored_file();
        $talk = Oden::Response::Dictionary->new(+{
            filename    => $filename,
            auto_remove => 1
        });
    }
    elsif($hear =~ m{\A(?:rename|move)\s+(.*)\s+(.*)}){
        my $before = $1;
        my $after  = $2;
        my $res = $dict->move($before, $after);
        $talk  .= $res ?
          sprintf("changed: %s => %s", $before, $after) :
          sprintf("cant find %s", $before);
    }
    elsif($hear =~ m{\A(?:get|show)\s+(.+)}){
        my $key    = $1;
        my $res = $dict->get($key);
        $talk .= $res              if     $res;
        $talk .= 'not registrated' unless $res;
    }
    elsif($hear =~ m{(?:add|set)\s([^\s]+)\s+}){
        my $key    = $1;
        my $value  = $hear;
        $value =~s{(add|set)\s+$key\s*}{};
        my $res = $dict->set($key => $value);
        $talk .= 'registrated'      if $res;
        $talk .= 'the key already exists' unless $res;
    }
    elsif($hear =~ m{(?:overwrite)\s([^\s]+)\s+}){
        my $key    = $1;
        my $value  = $hear;
        $value =~s{(overwrite)\s+$key\s*}{};
        my $res = $dict->overwrite($key => $value);
        $talk .= 'overwrote'       if     $res;
        $talk .= 'not registrated' unless $res;
    }
    elsif($hear =~ m{(?:delete|remove)\s+(.+)}){
        my $key    = $1; 
        my $res = $dict->remove($key);
        $talk .= 'removed'             if $res;
        $talk .= 'not registrated' unless $res;
    }

    return $talk;
}

1;

=head1 SEE ALSO

  Oden

=cut
