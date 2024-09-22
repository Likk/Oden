use 5.40.0;
use autodie;

use Test::Spec;
use Test::Exception;

use Oden::Model::Dictionary;
use Storable qw/retrieve/;

local $ENV{DICT_DIR} = '/tmp/oden_model_dictionary';

describe 'about Oden::Model::Dictionary#new' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{file} = 'new.dat';
        mkdir $ENV{DICT_DIR} if !-d $ENV{DICT_DIR};
    };

    after all => sub {
         unlink sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file}) if -e sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file});
         rmdir $ENV{DICT_DIR};
    };

    context 'Positive testing' => sub {
        context 'case constructor' => sub {
            it 'when create new instance' => sub {
                my $dictionary = Oden::Model::Dictionary->new(+{
                    file_name => $hash->{file}
                });
                isa_ok $dictionary, 'Oden::Model::Dictionary', 'create new instance';
            };
        };
    };
};

runtests();
