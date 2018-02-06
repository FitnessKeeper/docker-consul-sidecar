#!/usr/bin/dumb-init /bin/sh
set -e
/usr/local/bin/create_check.sh > /consul_check_definitions/docker-test.json
while true ; do echo "I am sleeping"; sleep 60;done
