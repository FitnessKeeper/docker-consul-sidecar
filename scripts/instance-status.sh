#!/bin/bash
set -e 

REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed 's/.$//')
ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
ARN=$(curl -s http://localhost:51678/v1/metadata | jq -r .ContainerInstanceArn)
ECS_CLUSTER=$(curl -s http://localhost:51678/v1/metadata | jq -r .Cluster)
#ASG=$(aws ec2 describe-instances --region $REGION --instance-ids $ID | jq -r '.Reservations[0].Instances[0].Tags[1].Value')
CONTAINER_INSTANCE_STATUS=$(aws --region $REGION ecs describe-container-instances --cluster $ECS_CLUSTER --container-instances "$ARN" | jq -r .containerInstances[0].status)
STATUS=$(aws --region $REGION autoscaling describe-auto-scaling-instances --instance-ids $ID | jq -r '.AutoScalingInstances[0].LifecycleState')

if [ $STATUS = "InService" ]; then
  echo Status is Lifecycle State : $STATUS
  echo ECS Instance Status       : $CONTAINER_INSTANCE_STATUS
elif [ $STATUS = "Terminating:Wait" ]; then
  aws --region $REGION ecs update-container-instances-state --cluster $ECS_CLUSTER --container-instances $ARN --status DRAINING
  echo Status is Lifecycle State : $STATUS
  echo ECS Instance Status       : $CONTAINER_INSTANCE_STATUS
  exit 255
else
  echo Status is Lifecycle State : $STATUS
  echo ECS Instance Status       : $CONTAINER_INSTANCE_STATUS
  exit 1
fi
