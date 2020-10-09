#!/usr/bin/env bash
set -e

# Get addresses of hosts from stacks.
REPORTS_STACK=micca-reports
BASTION_STACK=micca-reports-bastion

REPORT_IPV6=$( aws cloudformation describe-stacks\
  --stack-name ${REPORTS_STACK} \
  --query "Stacks[].Outputs[?OutputKey=='ReportIPv6'].OutputValue" \
  --output text )

BASTION_IPV6=$( aws cloudformation describe-stacks\
  --stack-name ${BASTION_STACK} \
  --query "Stacks[].Outputs[?OutputKey=='BastionIPv6'].OutputValue" \
  --output text )

echo $REPORT_IPV6
echo $BASTION_IPV6

echo "Connecting"

# Form ssh command
ssh -A -6 -J "ec2-user@[${BASTION_IPV6}]" "ubuntu@${REPORT_IPV6}"
