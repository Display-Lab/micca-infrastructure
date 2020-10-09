# Report instance setup

Stand up AWS infrastructure for micca report generation.
Provides the prerequisites for the instance scheduler.

## Set deployment parameters
- Copy `params-deploy.example.json` to `params-deploy.json`
- Copy `params-deploy-bastion.example.json` to `params-deploy-bastion.json`
- Edit parameter files for your organization.

### AWS Image

The `aws ec2 describe-images` does not currently have a filter that allows pulling a list of Canonical's offerings.

Get the most recent image id for Ubuntu Focal from Canonical using the product id from the AWS Marketplace.
```sh
aws ec2 describe-images \
  --filters Name=product-code,Values=a8jyynf4hjutohctm41o2z18m \
  --query 'sort_by(Images, &CreationDate)[-1].[ImageId]'
```

## Deploy
Convenience script for deploying core VPC and report EC2 instance:
```sh
./deploy-core.sh
```

Deployment of bastion host permits ssh access to configure report instance.
This stack depends on values exported from the core reports stack.
```sh
./deploy-bastion.sh
```

## Teardown
The bastion stack can be deleted when access is not longer required.
The bastion stack must be deleted beore the core stack can be deleted.
```sh
./teardown-bastion.sh
```

Convenience script for deleting the core reports stack.
```sh
./teardown-core.sh
```

## Report instance scheduler

Schedule an EC2 instance to be brought up and run once a month to generate reports.

### Requirements
An existing EC2 instance with:
  - report generation dependencies installed.
  - permission to read performance data from appropriate bucket.
  - permission to push reports to appropriate bucket.
  - ability to respond to cloudwatch event

### Infrastructure Design
AWS Instance Scheduler to start/stop EBS backed EC2 instance.
  - Cloudwatch
  - DynamoDB
  - Lambda

How to coordinate running the reports on the EC2 instance?
  - run file with timestamp of last run
  - cloudwatch event to fire on ec2 instance up

Log to cloudtrail run start, stop, success, & fail.

If pricing becomes an issue for EBS gb/month could try:
  - Snapshot on stop & restort prior to start to use EBS snapshots
  - Cold HDD Volume for root? might be very slow.


