#!/bin/bash

DOCKER_ID=$(head -1 /proc/self/cgroup  | cut -d'/' -f4)

_CHECK=$(cat <<EOT
{
"check": {
    "id": "docker-test-warning",
    "name": "docker test warning",
    "docker_container_id": "${DOCKER_ID}",
    "shell": "/bin/bash",
    "args": ["/usr/local/bin/dummy.sh warning"],
    "interval": "10s"
  }
}
EOT
)

echo ${_CHECK}
