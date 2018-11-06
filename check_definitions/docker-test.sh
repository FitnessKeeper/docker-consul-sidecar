#!/bin/bash

DOCKER_ID=$(awk -F/ '{ print $NF }' /proc/1/cpuset)

_CHECK=$(cat <<EOT
{
"check": {
    "id": "docker-test",
    "name": "docker test",
    "docker_container_id": "${DOCKER_ID}",
    "shell": "/bin/bash",
    "args": ["/usr/local/bin/dummy.sh"],
    "interval": "10s"
  }
}
EOT
)

echo ${_CHECK}
