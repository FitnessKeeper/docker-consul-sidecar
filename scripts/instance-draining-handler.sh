#!/bin/bash
# We probably want to replace this with something that eats json and do this in a non-horrible way
# It would safe clock time to get status from the JSON input of the consul watch.

REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed 's/.$//')
ARN=$(curl -s http://localhost:51678/v1/metadata | jq -r .ContainerInstanceArn)
ECS_CLUSTER=$(curl -s http://localhost:51678/v1/metadata | jq -r .Cluster)
ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
STATUS=$(aws --region $REGION autoscaling describe-auto-scaling-instances --instance-ids $ID | jq -r '.AutoScalingInstances[0].LifecycleState')

if [ $STATUS = "Terminating:Wait" ]; then
  aws --region $REGION ecs update-container-instances-state --cluster $ECS_CLUSTER --container-instances $ARN --status DRAINING
  exit 0
else
  exit 0
fi
