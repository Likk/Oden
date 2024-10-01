use strict;
use warnings;

use Test::Exception;
use Test::Spec;
use Oden::Command::Group;
use String::Random;

describe 'about Oden::Command::Group#make_group' => sub {
    my $hash;
    share %$hash;

    # Negative testing
    context 'Negative testing' => sub {
        context 'case call make_group method without arguments' => sub {
            it 'when throws exception' => sub {
                throws_ok {
                    Oden::Command::Group->make_groups();
                } qr/Too few arguments for fun make_groups/;
            };
        };
        context 'case call make_group method with 1 hash arguments' => sub {
            # size only
            they 'where throws exception' => sub {
                # size only
                throws_ok {
                    Oden::Command::Group->make_groups(
                        size => 2,
                    );
                } qr/Too few arguments for fun make_groups/;
                # members only
                throws_ok {
                    Oden::Command::Group->make_groups(
                        members => ['foo', 'bar'],
                    );
                } qr/Too few arguments for fun make_groups/;
            };
        };
        context 'case members arugment is empty' => sub {
            it 'when returns empty array' => sub {
                my $res = Oden::Command::Group->make_groups(
                    size    => 3,
                    members => [],
                );
                is $res, undef;
            };
        };
    };

    context 'Positive testing' => sub {
        context 'case call make_group method with 2 hashes arguments' => sub {
            context 'case size equals or less than members' => sub {
                they 'when returns array lenth equals size' => sub {
                    my $members = ['one', 'two', 'three', 'four', 'five', 'six', 'seven'];
                    for my $size (1..7){
                        my $res = Oden::Command::Group->make_groups(
                            size    => $size,
                            members => $members,
                        );
                        is scalar @$res, $size;
                    }
                };
            };
            context 'case size greater than members' => sub {
                they 'when returns array lenth equals members' => sub {
                    my $members = ['one', 'two', 'three', 'four', 'five', 'six', 'seven'];
                    for my $size (8..10){
                        my $res = Oden::Command::Group->make_groups(
                            size    => $size,
                            members => $members,
                        );
                        is scalar @$res, scalar @$members;
                    }
                };
            };

            context 'cast members argument is ArrayRef[Str]' => sub {
                it "Everyone's been put into a group / with no duplicates" => sub {
                    for (1..10){
                        my $members = [map { String::Random->new->randregex("[A-Za-z]{3,10}") } 1..int(rand(10)) + 1];
                        my $res = Oden::Command::Group->make_groups(
                            size    => 3,
                            members => $members,
                        );

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
};

runtests();
