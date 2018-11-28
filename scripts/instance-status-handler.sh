#!/bin/sh
# shellcheck shell=sh
# We probably want to replace this with something that eats json and do this in a non-horrible way

sleep 10
/usr/local/bin/instance-status.sh

RC=$?

if [ $RC = 255 ]; then
  sleep 90
  /bin/consul maint -enable
  /bin/consul leave
else
  echo InstanceStatus is ok
  exit 0
fi
