#!/usr/bin/env bash

set -e

APP_NAME=wordpress-basic
aws_region=eu-west-1
tfstate_name=${APP_NAME}.tfstate.d
tfstate_s3_bucket=${tfstate_name}
tfstate_dynamodb_table=${tfstate_name}

if [ -z "${APP_NAME// }" ]; then
  echo "Please define APP_NAME environment variable"
  exit 1
fi

. venv/bin/activate
pip install -r requirements.txt

aws s3 mb s3://${tfstate_s3_bucket} \
    --region "${aws_region}" \

aws s3api put-bucket-versioning \
    --region "${aws_region}" \
    --bucket "${tfstate_s3_bucket}" \
    --versioning-configuration "Status=Enabled"

aws dynamodb create-table \
    --region "${aws_region}" \
    --table-name "${tfstate_dynamodb_table}" \
    --key-schema "AttributeName=LockID,KeyType=HASH" \
    --provisioned-throughput "ReadCapacityUnits=5,WriteCapacityUnits=5" \
    --attribute-definitions "AttributeName=LockID,AttributeType=S AttributeName=Digest,AttributeType=S"

deactivate
