use 5.40.0;
use autodie;

use Test::Spec;
use Test::Exception;

use Oden::Model::Dictionary;
use Storable qw/retrieve/;

local $ENV{DICT_DIR} = '/tmp/oden_model_dictionary';

describe 'about Oden::Model::Dictionary#set' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{file} = 'set.dat';
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
                    $hash->{dictionary}->set();
                } qr/Too few arguments for method set/, 'no parameter';
            };
        };
        context 'case no key' => sub {
            it 'when return 0' => sub {
                my $res =  $hash->{dictionary}->set('' => 'bar');
                is $res, 0, 'no key';
            };
        };
        context 'case no value' => sub {
            it 'when return 0' => sub {
                my $res = $hash->{dictionary}->set('foo' => '');
                is $res, 0, 'no value';
            };
        };
    };

    context 'Positive testing' => sub {
        context 'case call set method' => sub {
           it 'when return 1' => sub {
                my $dictionary = $hash->{dictionary};
                my $res = $dictionary->set('foo' => 'bar');
                is $res, 1, 'set correct';
            };

            it 'when write file' => sub {
                my $table = retrieve(sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file}));
                is $table->{foo}, 'bar', 'write file correct';
            };
        };

        context 'case call set already exists key' => sub {
            it 'when dont overwrite' => sub {
                my $dictionary = $hash->{dictionary};
                my $res = $dictionary->set('foo' => 'bar2');
                is $res, 0, 'already exists key';
            };
        };
    };
};

runtests();
