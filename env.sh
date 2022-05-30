#!/bin/sh
set -e

export EDITOR=vim;
export PATH="local/bin:$PATH"
export PERL5LIB="local/lib/perl5:./lib"
export LANG="C";

exec "$@"
