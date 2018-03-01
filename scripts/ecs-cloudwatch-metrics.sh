#!/bin/bash
#Usage:
# Push metrics into cloudwatch

#./ecs-cloudwatch-metric.sh
#

REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed 's/.$//')
ECS_CLUSTER=$(curl -s http://localhost:51678/v1/metadata | jq -r .Cluster)
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

aws --region ${REGION} cloudwatch put-metric-data --metric-name ContainerInstancesCount --namespace /AWS/ECS --dimensions Cluster=${ECS_CLUSTER} --value 1 --timestamp ${TIMESTAMP}
exit 0
