#!/bin/bash
#Usage:
# Consul health check to check if my running AMI matches the AMI defined in
# The Launch Configurations exits 0 if true, and 1 (warning) if false

#./ami_up2date.sh
#

REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed 's/.$//')
MY_AMI=$(curl -s http://169.254.169.254/latest/meta-data/ami-id/)
MY_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
#ASG=$(aws ec2 describe-instances --region $REGION --instance-ids $MY_INSTANCE_ID | jq -r '.Reservations[0].Instances[0].Tags[1].Value')
#STATUS=$(aws autoscaling describe-auto-scaling-instances --instance-ids $MY_INSTANCE_ID --region $REGION | jq -r '.AutoScalingInstances[0].LifecycleState')

AS_GROUP_NAME=$(aws --region $REGION autoscaling describe-auto-scaling-instances --instance-ids $MY_INSTANCE_ID | jq -r .AutoScalingInstances[0].AutoScalingGroupName)
LAUNCH_CONFIG_NAME=$(aws --region $REGION autoscaling describe-auto-scaling-groups --auto-scaling-group-names $AS_GROUP_NAME | jq -r .AutoScalingGroups[0].LaunchConfigurationName)
# curl http://169.254.169.254/latest/meta-data/placement/availability-zone
LAUNCH_CONFIG_AMI=$(aws --region $REGION autoscaling describe-launch-configurations --launch-configuration-names $LAUNCH_CONFIG_NAME | jq -r .LaunchConfigurations[0].ImageId)

if [[ $MY_AMI == $LAUNCH_CONFIG_AMI ]];then
  echo "Running AMI (${MY_AMI}) is current"
  exit 0
else
  echo "Running AMI: ${MY_AMI}, is out of date. It should be: ${LAUNCH_CONFIG_AMI}"
  # Set health check to warning so that discovery still works
  exit 1
fi
