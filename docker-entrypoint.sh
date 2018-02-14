#!/usr/bin/dumb-init /bin/sh
set -e

# chmod to work around this issue
# https://github.com/hashicorp/docker-consul/issues/50
chmod a+w /var/run/docker.sock

SCRIPT_SUFFIX=".sh"
JSON_SUFFIX=".json"

if [ -n "$CHECKS" ]; then
   for CHECK in $(echo "${CHECKS}" | jq -r '.[]' ); do
     echo "Creating Consul check definition :  $CHECK"
     cd /usr/local/bin/check_definitions
     ./${CHECK}${SCRIPT_SUFFIX} > /consul_check_definitions/${CHECK}${JSON_SUFFIX}
   done
fi

while true ; do echo "I am sleeping"; sleep 60;done
#/bin/bash
