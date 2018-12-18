#!/usr/bin/dumb-init /bin/sh
set -e

# chmod to work around this issue
# https://github.com/hashicorp/docker-consul/issues/50
chmod a+w /var/run/docker.sock

SCRIPT_SUFFIX=".sh"
JSON_SUFFIX=".json"

# Make sure you start with a clean check dir
rm -f /consul_check_definitions/*.json

if [ -n "$CHECKS" ]; then
   #for CHECK in $(echo "${CHECKS}" | jq -r '.[]' ); do
   for CHECK in ${CHECKS}; do
     echo "Creating Consul check definition :  $CHECK"
     cd /usr/local/bin/check_definitions
     ./${CHECK}${SCRIPT_SUFFIX} > /consul_check_definitions/${CHECK}${JSON_SUFFIX}
   done
fi

cd /etc/consul-esm.d
./config.hcl.sh > config.hcl
consul-esm -config-file=/etc/consul-esm.d/config.hcl
