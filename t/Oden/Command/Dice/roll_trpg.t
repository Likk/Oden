use strict;
use warnings;

use Test::Exception;
use Test::Spec;
use Oden::Command::Dice;
use String::Random;

describe 'about Oden::Command::Dice#roll_trpg' => sub {
    my $hash;
    share %$hash;

    context 'Negative testing' => sub {
        context 'case call roll_trpg method without arguments' => sub {
            it 'when throws exception' => sub {
                throws_ok {
                    Oden::Command::Dice::roll_trpg();
                } qr/Too few arguments for fun roll_trpg/;
            };
            it 'when throws exception' => sub {
                throws_ok {
                    Oden::Command::Dice->roll_trpg();
                } qr/Too few arguments for fun roll_trpg/;
            };
        };
        context 'case call roll_trpg method with not expected arguments' => sub {
            it 'when throws exception' => sub {
                throws_ok {
                    Oden::Command::Dice->roll_trpg(undef);
                } qr/did not pass type constraint/;
            };
            it 'when throws exception' => sub {
                throws_ok {
                    my $random_class = bless {}, sprintf('Oden::Entity::%s', String::Random->new->randregex("[A-Za-z]{3,10}"));
                    Oden::Command::Dice->roll_trpg($random_class);
                } qr/did not pass type constraint/;
            };

        };
    };

    context 'Positive testing' => sub {
        context 'case call roll_trpg method with 2 hashes arguments' => sub {
            context 'case dont match tpgs like roll pattern' => sub {
                they 'when return empty string' => sub {
                    my $roll_string_list = [
                        '',      # dont match empty pattern
                        '2A6',   # dont match "Dice" pattern
                        'nD6',   # dont match unit pattern
                        '2dm',   # dont match sided pattern
                        '2d6\2', # dont match sign pattern
                        '2d6+r', # dont match offset pattern
                    ];
                    for my $roll_string (@$roll_string_list) {
                        my $res = Oden::Command::Dice->roll_trpg($roll_string);
                        is $res, '', sprintf("return empty string: %s", $roll_string);
                    };
                };
            };
            context 'case match tpgs like and single dice roll pattern' => sub {
                context 'case digit dice' => sub {
                    they 'when return digit value' => sub {
                        my $roll_string_list = [
                            '1d6',   # match "Dice" pattern
                            '1D6',
                            '1d6+1', # match sign pattern
                            '1d6-1',
                            '1d6*1',
                            '1d6/1',
                            '1d6x1',
                            '1d6X1',
                            '1d6b1', # match best of dice pattern
                            '1d6B1',
                        ];
                        for my $roll_string (@$roll_string_list) {
                            my $res = Oden::Command::Dice->roll_trpg($roll_string);
                            # 1d6 => 1-6
                            # 1d6+1 => 2-7
                            # 1d6-1 => 0-5
                            # 1d6*1 => 1-6 // same xX
                            # 1d6/1 => 1-6
                            # 1d6b1 => 1-6
                            like $res, qr/\A[01234567]\z/, sprintf("return string: %s", $roll_string);
                        };
                    };
                };
                context 'case fudge dice' => sub {
                    they 'when return digit value' => sub {
                        my $roll_string_list = [
                            '1dF',   # match "Dice" pattern
                            '1dF+1', # match sign pattern
                            '1dF-1',
                            '1dF*1',
                            '1dF/1',
                            '1dFb1', # match best of dice pattern
                        ];
                        for my $roll_string (@$roll_string_list) {
                            my $res = Oden::Command::Dice->roll_trpg($roll_string);
                            # 1dF   => -0+
                            # 1dF** => -0+ // Fudge dice is not support four arithmetic operations.
                            like $res, qr/[\-0+]/, sprintf("return string: %s", $roll_string);
                        };
                    };
                };
            };
            context 'case match tpgs like and multiple dice roll pattern' => sub {
                context 'case digit dice' => sub {
                    they 'when return digit value' => sub {
                        my $roll_string_list = [
                            '3d10',   # match "Dice" pattern
                            '3d10',
                            '3d10+2', # match sign pattern
                            '3d10-2',
                            '3d10*2',
                            '3d10/2',
                            '3d10x2',
                            '3d10X2',
                            '3d10b2', # match best of dice pattern
                            '3d10B2',
                        ];
                        for my $roll_string (@$roll_string_list) {
                            my $res = Oden::Command::Dice->roll_trpg($roll_string);
                            # 3d10   => 3-30
                            # 3d10+2 => 5-32
                            # 3d10-2 => 1-28
                            # 3d10*2 => 6-60
                            # 3d10/2 => 1-15
                            # 3d10x2 => 6-60
                            # 3d10X2 => 6-60
                            # 3d10b2 => 2-20
                            # 3d10B2 => 2-20

                            # remove CRITICAL!! and FUMBLE!! case.
                            $res =~ s/(CRITICAL|FUMBLE)!!\s//g;
                            like $res, qr/total:
                              ([123456789][0-9]?)
                              \s
                              \(
                                (\d0?\s?){3}
                              \)/x, sprintf("return string: %s", $roll_string);
                        };
                    };
                };
                context 'case fudge dice' => sub {
                    they 'when return digit value' => sub {
                        my $roll_string_list = [
                            '3dF',   # match "Dice" pattern
                            '3dF+2', # match sign pattern
                            '3dF-2',
                            '3dF*2',
                            '3dF/2',
                            '3dFb2', # match best of dice pattern
                        ];
                        for my $roll_string (@$roll_string_list) {
                            my $res = Oden::Command::Dice->roll_trpg($roll_string);
                            # 3dF   => -0+
                            # 3dF** => -0+ // Fudge dice is not support four arithmetic operations.
                            like $res, qr/
                              ([\-0+],?){3}
                              /x, sprintf("return string: %s", $roll_string);
                        };
                    };
                };
            };
            context 'case CRITICAL!!' => sub {
                before all => sub {
                    #Games::Dice::roll_array export to Oden::Command::Dice::roll_array
                    $hash->{stub}->{GamesDiceRollArray} = Oden::Command::Dice->stubs(
                        roll_array => sub {
                            return (6, 6, 6);
                        },
                    );
                };
                after all => sub {
                    delete $hash->{stub}->{GamesDiceRollArray};
                };
                it 'when return CRITICAL!!' => sub {
                    my $res = Oden::Command::Dice->roll_trpg('3d6');
                    is $res, 'CRITICAL!! total:18 (6 6 6)', 'return CRITICAL!!';
                };
            };
            context 'case FUMBLE!!' => sub {
                before all => sub {
                    $hash->{stub}->{GamesDiceRollArray} = Oden::Command::Dice->stubs(
                        roll_array => sub {
                            return (1, 1, 1);
                        },
                    );
                };
                after all => sub {
                    delete $hash->{stub}->{GamesDiceRollArray};
                };
                it 'when return FUMBLE!!' => sub {
                    my $res = Oden::Command::Dice->roll_trpg('3d6');
                    is $res, 'FUMBLE!! total:3 (1 1 1)', 'return FUMBLE!!';
                };
            };
        };
    };
};

runtests();
