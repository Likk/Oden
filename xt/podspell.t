use Test::More;

eval q{ use Test::Spelling };
plan skip_all => "Test::Spelling is not installed." if $@;

add_stopwords(map { split /[\s\:\-]/ } <DATA>);
all_pod_files_spelling_ok('lib');

my $d = do { no strict 'refs'; \*{"main::DATA"} };

__DATA__
XXX
critf
warnf
infof
