use strict;
use warnings;

use Test::Spec;
use Oden::Command::Group;
use String::Random;

describe 'about Oden::Command::Group#make_group' => sub {
    my $hash;
    share %$hash;

    # Negative testing
    context 'case call make_group method without arguments' => sub {
        it 'when returns undef' => sub {
            my $res = Oden::Command::Group->make_groups();
            is $res, undef;
        };
    };

    context 'case call make_group method with 1 arguments' => sub {
        # size only
        it 'when returns undef' => sub {
            my $res = Oden::Command::Group->make_groups({
                size => 2,
            });
            is $res, undef;
        };
        # members only
        it 'when returns undef' => sub {
            my $res = Oden::Command::Group->make_groups({
                members => ['foo', 'bar'],
            });
            is $res, undef;
        };
    };

    # Positive testing
    context 'case call make_group method with 2 arguments' => sub {
        context 'case size argument is N' => sub {
            it 'when returns N groups' => sub {
                for (1..10){
                    my $size = int(rand(10)) + 1;
                    my $res = Oden::Command::Group->make_groups({
                        size    => $size,
                        members => ['foo', 'bar'],
                    });
                    is scalar @$res, $size;
                }
            };
        };

        context 'cast members argument is ArrayRef[Str]' => sub {
            it "Everyone's been put into a group / with no duplicates" => sub {
                for (1..10){
                    my $members = [map { String::Random->new->randregex("[A-Za-z]{3,10}") } 1..int(rand(10)) + 1];
                    my $res = Oden::Command::Group->make_groups({
                        size    => 3,
                        members => $members,
                    });

                    for my $member (@$members){
                        my $found = 0;
                        for my $group (@$res){
                            $found++ if(grep { $_ eq $member } @$group);
                        }
                        is $found, 1;
                    }
                }
            };
        };
    };
};

runtests();
