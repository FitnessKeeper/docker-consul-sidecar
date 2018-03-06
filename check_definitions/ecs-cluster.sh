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
        "notes": "Compares the running AMI to the AMI defined in the launch config",
        "docker_container_id": "${DOCKER_ID}",
        "shell": "/bin/bash",
        "args": ["/usr/local/bin/ami_up2date.sh"],
        "interval": "10s",
        "status": "passing"
      },
      {
        "id": "ecs-cloudwatch",
        "name": "ECS CloudWatch",
        "notes": "Send Metrics to CloudWatch",
        "docker_container_id": "${DOCKER_ID}",
        "shell": "/bin/bash",
        "args": ["/usr/local/bin/ecs-cloudwatch-metrics.sh"],
        "interval": "60s",
        "status": "passing"
      },
      {
        "id": "instance-status",
        "name": "Instance Status",
        "notes": "Instance and ECS Instance Status",
        "docker_container_id": "${DOCKER_ID}",
        "shell": "/bin/bash",
        "args": ["/usr/local/bin/instance-status.sh"],
        "interval": "60s",
        "status": "passing"
      }
    ]
  },
  "watches":
    [
      {
        "type": "checks",
        "service": "${ECS_CLUSTER}",
        "handler": "/usr/local/bin/instance-draining-handler.sh"
      }
    ]
}
EOT
)

echo ${_SERVICE}
