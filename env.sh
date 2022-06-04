#!/bin/sh
set -e

export EDITOR=vim;
export PATH="local/bin:$PATH"
export PERL5LIB="local/lib/perl5:./lib"
export LANG="C";

export BASE_DIR=$(cd $(dirname $0); pwd)
export DATA_DIR=${BASE_DIR}/data

exec "$@"
