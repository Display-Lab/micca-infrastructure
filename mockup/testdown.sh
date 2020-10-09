#!/usr/bin/env bash
set -e

aws cloudformation delete-stack \
  --stack-name cag-import-demo

aws cloudformation wait stack-delete-complete \
  --stack-name cag-import-demo

