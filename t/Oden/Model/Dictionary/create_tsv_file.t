use 5.40.0;
use autodie;

use Test::Spec;
use Test::Exception;

use Oden::Model::Dictionary;
use Storable qw/retrieve/;

local $ENV{DICT_DIR} = '/tmp/oden_model_dictionary';

describe 'about Oden::Model::Dictionary#create_tsv_file' => sub {
    my $hash;
    share %$hash;

    before all => sub {
        $hash->{file} = 'create_tsv_file.dat';
        mkdir $ENV{DICT_DIR} if !-d $ENV{DICT_DIR};

        my $dictionary = Oden::Model::Dictionary->new(+{
            file_name => $hash->{file}
        });
        $hash->{dictionary} = $dictionary;
    };

    after all => sub {
         unlink sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file}) if -e sprintf("%s/%s", $ENV{DICT_DIR}, $hash->{file});
         rmdir $ENV{DICT_DIR};
    };

    context 'Positive testing' => sub {
        context 'case empty dictionary' => sub {
            it 'when create empty create_tsv_file' => sub {
                my $dictionary = $hash->{dictionary};
                my $filename = $dictionary->create_tsv_file();
                my $tsv = do {
                    local $/;
                    open my $fh, '<', $filename;
                    <$fh>
                };
                is $tsv, '', 'empty dictionary';
            };
        };
        context 'case dictionary has key' => sub {
            before all => sub {
                $hash->{dictionary}->set('foo' => 'bar');
            };
            it 'when create create_tsv_file' => sub {
                my $dictionary = $hash->{dictionary};
                my $filename = $dictionary->create_tsv_file();
                my $tsv = do {
                    local $/;
                    open my $fh, '<', $filename;
                    <$fh>
                };
                is $tsv, "foo\tbar\n", 'dictionary has key';
            };
        };
    };
};

runtests();
