#!/bin/bash

DOCKER_ID=$(awk -F/ '{ print $NF }' /proc/1/cpuset)

_CHECK=$(cat <<EOT
{
"check": {
    "id": "docker-test-critical",
    "name": "docker test critical",
    "docker_container_id": "${DOCKER_ID}",
    "shell": "/bin/bash",
    "args": ["/usr/local/bin/dummy.sh", "failing"],
    "interval": "10s"
  }
}
EOT
)

echo ${_CHECK}
