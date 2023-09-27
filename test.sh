#!sh
set -ue

if [ $# -gt 0 ]; then
  ./env.sh forkprove -MOden::Preload -lvr $1
else
  ./env.sh forkprove -MOden::Preload -lvr ./t
fi
