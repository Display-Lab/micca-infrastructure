#!/usr/bin/env bash
set -e

# Provide from environment or use default
STACK_NAME=${STACK_NAME:-micca-reports}

# Create stack
aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --template-body file://template-core.yml \
  --parameters file://params-core.json \
  --capabilities CAPABILITY_IAM

aws cloudformation wait stack-create-complete \
  --stack-name ${STACK_NAME} 

aws cloudformation describe-stack-events \
  --stack-name ${STACK_NAME} |\
  jq '.StackEvents[] | [.LogicalResourceId, .ResourceType, .ResourceStatus, .Timestamp] | join(" ")' |\
  awk -F' ' '{printf "%-20s %-35s %-20s %10s\n", $1, $2, $3, substr($4, 12, 8)}'

echo -e "\n"

aws cloudformation describe-stacks \
  --stack-name ${STACK_NAME} |\
  jq '.Stacks[] | .Outputs'


