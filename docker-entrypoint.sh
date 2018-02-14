#!/usr/bin/dumb-init /bin/sh
set -e

# chmod to work around this issue
# https://github.com/hashicorp/docker-consul/issues/50
chmod a+w /var/run/docker.sock

SCRIPT_SUFFIX=".sh"
JSON_SUFFIX=".json"

if [ -n "$CHECKS" ]; then
   for CHECK in $CHECKS; do
     echo "creating $CHECK Consul check definition"
     cd /usr/local/bin
     ./${CHECK}${SCRIPT_SUFFIX} > /consul_check_definitions/${CHECK}${JSON_SUFFIX}
   done
fi
#/usr/local/bin/docker-test.sh > /consul_check_definitions/docker-test.json
while true ; do echo "I am sleeping"; sleep 60;done
#/bin/bash
