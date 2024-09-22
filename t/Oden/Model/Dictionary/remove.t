use 5.40.0;
use autodie;

use Test::Spec;
use Test::Exception;

use Oden::Model::Dictionary;
use Storable qw/retrieve/;

local $ENV{DICT_DIR} = '/tmp/oden_model_dictionary';

describe 'about Oden::Model::Dictionary#remove' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{file} = 'remove.dat';
        mkdir $ENV{DICT_DIR} if !-d $ENV{DICT_DIR};

        my $dictionary = Oden::Model::Dictionary->new(+{
            file_name => $hash->{file},
        });
        $hash->{dictionary} = $dictionary;
    };

    after all => sub {
         unlink sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file}) if -e sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file});
         rmdir $ENV{DICT_DIR};
    };

    context 'Negative testing' => sub {
        context 'case no parameter' => sub {
            it 'when no parameter' => sub {
                throws_ok {
                    $hash->{dictionary}->remove();
                } qr/Too few arguments for method remove/, 'no parameter';
            };
        };
        context 'case no key' => sub {
            it 'when return 0' => sub {
                my $res =  $hash->{dictionary}->remove('');
                is $res, 0, 'no key';
            };
        };
    };

    context 'Positive testing' => sub {
        context 'case doesnt exist key' => sub {
           it 'when return 0' => sub {
                my $dictionary = $hash->{dictionary};
                my $res = $dictionary->remove('foo');
                is $res, 0, 'cant remove';
            };
        };

        context 'case already exists key' => sub {
            before all => sub {
                $hash->{dictionary}->set('foo' => 'bar');
            };
            it 'when can remove' => sub {
                my $dictionary = $hash->{dictionary};
                my $res = $dictionary->remove('foo');

                is $res, 1, 'remove correct';
                is $dictionary->get('foo'), undef, 'remove correct';
            };
        };
    };
};

runtests();
