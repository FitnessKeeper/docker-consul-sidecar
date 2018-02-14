#!/bin/bash

DOCKER_ID=$(head -1 /proc/self/cgroup  | cut -d'/' -f4)

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
