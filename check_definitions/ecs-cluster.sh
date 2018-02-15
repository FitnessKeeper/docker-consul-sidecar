#!/bin/bash

ECS_CLUSTER=$(curl -s http://localhost:51678/v1/metadata | jq -r .Cluster)
DOCKER_ID=$(head -1 /proc/self/cgroup  | cut -d'/' -f4)

_SERVICE=$(cat <<EOT
{
  "service": {
    "name": "${ECS_CLUSTER}",
    "address": "",
    "tags": [
      "ecs"
    ],
    "checks": [
      {
        "id": "ami-up2date",
        "name": "AMI Status",
        "docker_container_id": "${DOCKER_ID}",
        "shell": "/bin/bash",
        "args": ["/usr/local/bin/ami_up2date.sh"],
        "interval": "10s",
        "status": "passing"
      }
    ]
  }
}
EOT
)

echo ${_SERVICE}
