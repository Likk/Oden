use 5.40.0;
use autodie;

use Test::Spec;
use Test::Exception;

use Oden::Model::Dictionary;

local $ENV{DICT_DIR} = './t/Oden/Model/Dictionary/data/';

describe 'about Oden::Model::Dictionary#get' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{file} = 'get.dat';
         my $dictionary = Oden::Model::Dictionary->new(+{
              file_name => $hash->{file},
          });
        $hash->{dictionary} = $dictionary;
    };

    context 'Negative testing' => sub {
        context 'case no parameter' => sub {
            it 'when no parameter' => sub {
                throws_ok {
                    $hash->{dictionary}->get();
                } qr/Too few arguments for method get/, 'no parameter';
            };
        };
        context 'case no key' => sub {
            it 'when return undef' => sub {
                my $res =  $hash->{dictionary}->get('');
                is $res, undef, 'no key';
            };
        };
    };

    context 'Positive testing' => sub {
        context 'case call get that doesnt exist' => sub {

            it 'when get undef' => sub {
                my $dictionary = $hash->{dictionary};

                my $res = $dictionary->get('bar');
                is $res, undef, 'get undef';
            };
        };

        context 'case call get that exist' => sub {

            it 'when get value' => sub {
                my $dictionary = $hash->{dictionary};

                my $res = $dictionary->get('hoge');
                is $res, 'fuga', 'get value';
            };
        };
    };
};

runtests();
