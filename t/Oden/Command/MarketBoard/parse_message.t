use 5.40.0;
use Test2::V0;
use Test2::Tools::Spec;

use Oden::Command::MarketBoard;
use String::Random;

describe 'about Oden::Command::MarketBoard#parse_message' => sub {
    my $hash;

    describe 'Negative testing' => sub {
        describe 'case call parse_message method without arguments' => sub {
            it 'when throws exception' => sub {
                my $throws = dies {
                    my @res = Oden::Command::MarketBoard::parse_message();
                };

                like $throws, qr/Too few arguments for fun parse_message/;
            };
            it 'when throws exception' => sub {
                my $throws = dies {
                    my @res = Oden::Command::MarketBoard->parse_message();
                };

                like $throws, qr/Too few arguments for fun parse_message/;
            };
        };
        describe 'case call parse_message method with not expected arguments' => sub {
            it 'when throws exception' => sub {
                my $throws = dies {
                    my @res = Oden::Command::MarketBoard->parse_message(undef);
                };

                like $throws, qr/did not pass type constraint/;
            };
        };
    };

    describe 'Positive testing' => sub {
        describe 'case dont match pattern' => sub {
            tests 'when return empty array_ref' => sub {
                my $string_list = [
                    '',            # dont match empty pattern
                    'zeromus',     # target only pattern
                ];
                for my $string (@$string_list) {
                    my ($world_or_dc, $hq_flag, $item_name) = Oden::Command::MarketBoard->parse_message($string);
                    is $world_or_dc, undef, "return undef world_or_dc: %s";
                    is $hq_flag,     undef, "return undef hq_flag: %s";
                    is $item_name,   undef, "return undef item_name: %s";
                };
            };
        };
        describe 'case match pattern' => sub {
            tests 'when return array ref' => sub {
                my $string_list = [
                    'zeromus Lalafellin Kaftan',    # match world and item name pattern
                    'zeromus HQ Lalafellin Kaftan', # match world and HQ and item name pattern
                ];
                for my $string (@$string_list) {
                    my ($world_or_dc, $hq_flag, $item_name) = Oden::Command::MarketBoard->parse_message($string);
                    is $world_or_dc, 'zeromus',           sprintf("return world_or_dc: %s", $world_or_dc);
                    is $hq_flag,     'HQ',                sprintf("return hq_flag: %s", $hq_flag)         if $hq_flag;
                    is $item_name,   'Lalafellin Kaftan', sprintf("return item_name: %s", $item_name);
                }
            };
        };
    };
};

done_testing();
