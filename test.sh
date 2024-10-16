#!sh
set -ue

if [ $# -gt 0 ]; then
  ./env.sh forkprove -vr $1
else
  ./env.sh forkprove -r ./t
fi
