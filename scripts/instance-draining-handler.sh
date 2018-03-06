#!/bin/sh
# We probably want to replace this with something that eats json and do this in a non-horrible way

REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed 's/.$//')
ARN=$(curl -s http://localhost:51678/v1/metadata | jq -r .ContainerInstanceArn)
ECS_CLUSTER=$(curl -s http://localhost:51678/v1/metadata | jq -r .Cluster)

aws --region $REGION ecs update-container-instances-state --cluster $ECS_CLUSTER --container-instances $ARN --status DRAINING
#
#/usr/local/bin/instance-status.sh
#RC=$?

#if [ $RC = 255 ]; then
#  aws --region $REGION ecs update-container-instances-state --cluster $ECS_CLUSTER --container-instances $ARN --status DRAINING
#else
#  echo InstanceStatus is ok
#  exit 0
#fi
