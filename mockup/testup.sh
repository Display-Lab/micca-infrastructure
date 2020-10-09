#!/usr/bin/env bash
set -e

aws s3 mb s3://cag-importable

aws cloudformation create-change-set \
  --stack-name cag-import-demo \
  --change-set-name cag-import-changeset \
  --template-body file://persist-test.yaml \
  --change-set-type IMPORT \
  --resources-to-import file://resource-imports.json 

echo "Wait for changeset creation..."
aws cloudformation wait change-set-create-complete \
  --stack-name cag-import-demo \
  --change-set-name cag-import-changeset

aws cloudformation describe-change-set \
  --stack-name cag-import-demo \
  --change-set-name cag-import-changeset

aws cloudformation execute-change-set \
  --stack-name cag-import-demo \
  --change-set-name cag-import-changeset

# Put something in bucket so it's not empty.
echo "Hello World" | aws s3 cp - s3://cag-importable/hello.txt

# Delete changeset so we can re-use the name
aws cloudformation delete-change-set --change-set-name cag-import-changeset --stack-name cag-import-demo
