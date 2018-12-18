#!/bin/bash

ECS_CLUSTER=$(curl -s http://localhost:51678/v1/metadata | jq -r .Cluster)
if  [ -z "$ECS_CLUSTER" ]; then
   ECS_CLUSTER="default"
fi
DOCKER_ID=$(awk -F/ '{ print $NF }' /proc/1/cpuset)
BACKUP_INTERVAL=${1:-3600}

_SERVICE=$(cat <<EOT
{
  "service": {
    "name": "${ECS_CLUSTER}",
    "address": "",
    "tags": [
      "backup"
    ],
    "checks": [
      {
        "id": "consul-backup-job",
        "name": "Consul Backups",
        "notes": "Job that run to create a consul snapshot and backup to s3",
        "docker_container_id": "${DOCKER_ID}",
        "shell": "/bin/bash",
        "args": ["/usr/local/bin/backup.sh"],
        "interval": "${BACKUP_INTERVAL}s",
        "status": "passing"
      }
    ]
  }
}
EOT
)

echo "${_SERVICE}"



#{
#  "service": {
#    "name": "ConsulBackup",
#    "checks": [
#      {
#        "script": "/usr/local/bin/consul-backup.sh",
#        "status": "passing",
#        "interval": "3600s"
#      }
#    ]
#  }
#}
