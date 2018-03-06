#!/bin/bash
#Usage:
# Push metrics into cloudwatch

#./ecs-cloudwatch-metric.sh
#

REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed 's/.$//')
ECS_CLUSTER=$(curl -s http://localhost:51678/v1/metadata | jq -r .Cluster)
#ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
CONTAINERINSTANCES=$(aws --region ${REGION} ecs describe-clusters --clusters ${ECS_CLUSTER} | jq .clusters[0].registeredContainerInstancesCount)
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Commenting out to save CPU Cycles on smaller instances.
#aws --region ${REGION} cloudwatch put-metric-data --metric-name ContainerInstancesCount --namespace /AWS/ECS --dimensions Cluster=${ECS_CLUSTER} --unit Count --value 1 --timestamp ${TIMESTAMP}
aws --region ${REGION} cloudwatch put-metric-data --metric-name registeredContainerInstances --namespace /AWS/ECS --dimensions Cluster=${ECS_CLUSTER} --unit Count --value ${CONTAINERINSTANCES} --timestamp ${TIMESTAMP}
echo "Sending Metrics to CloudWatch"
exit 0
