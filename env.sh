#!/bin/sh
set -e

export EDITOR=vim;
export PATH="local/bin:$PATH"
export BASE_DIR=$(cd $(dirname $0); pwd)

export PERL5LIB="$BASE_DIR/local/lib/perl5:$BASE_DIR/lib"
export LANG="C";

export DATA_DIR=${BASE_DIR}/data

exec "$@"
