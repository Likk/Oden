use 5.40.0;
use Test2::V0;
use Test::Spelling;

add_stopwords(
    map {
        split /[\s\:\-]/
    }
    grep {
        $_ !~ /^#/
    } <DATA>
);
all_pod_files_spelling_ok('lib');

__DATA__
# annotation
XXX
# Oden::Logger
critf
warnf
infof
