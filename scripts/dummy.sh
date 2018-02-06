#!/bin/bash
#Usage:
# Dummy Consul health check to check
# exits 0 (passing) if $1 is not set, or anything else
# exits 1 (warning) if $1 is warning
# exits 2 (failing) if $1 is failing

#./dummy.sh passing|warning|failing
#

if [[ $1 == "failing" ]]; then
  echo "Failing"
  exit 2
elif [[ $1 == "warning" ]]; then
  echo "Warning"
  exit 1
else
  echo "Passing"
  exit 0
fi
