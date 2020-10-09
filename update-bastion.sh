#!/usr/bin/env bash
set -e

STACK_NAME=${STACK_NAME:-micca-reports-bastion}
CHANGE_SET=micca-cset-$(date +%Y%m%dT%H%M%S)

aws cloudformation create-change-set \
  --stack-name ${STACK_NAME} \
  --change-set-name ${CHANGE_SET} \
  --template-body file://template-bastion.yml \
  --parameters file://params-bastion.json \
  --change-set-type UPDATE \
  --capabilities CAPABILITY_IAM

aws cloudformation wait change-set-create-complete  \
  --stack-name ${STACK_NAME} \
  --change-set-name ${CHANGE_SET} 

aws cloudformation describe-change-set \
  --stack-name ${STACK_NAME} \
  --change-set-name ${CHANGE_SET}

aws cloudformation execute-change-set \
  --stack-name ${STACK_NAME} \
  --change-set-name ${CHANGE_SET}
