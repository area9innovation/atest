#!/usr/bin/env bash

# file name: mkTfBackend.sh

# This script creates a terraform state backend in an S3 bucket
# with AWS CLI configuration of which is expected to be present
# in ~/.aws. No local checks are being performed.

# Variables
# Use a bucket suffix to ensure a unique name
BUCKET_SUFF="4f3544fd2c4d6"
# Bucket name
BUCKET_NAME="atest-tf-backend-${BUCKET_SUFF}"
# AWS region to use
AWS_REGION="eu-north-1"

#--------------------------------------------
# Create S3 bucket
if aws s3api create-bucket \
  --bucket ${BUCKET_NAME} \
  --region ${AWS_REGION} \
  --acl private \
  --create-bucket-configuration LocationConstraint=${AWS_REGION}; then
    # Make the bucket encrypted
    aws s3api put-bucket-encryption \
      --bucket ${BUCKET_NAME} \
      --server-side-encryption-configuration "{\"Rules\": [{\"ApplyServerSideEncryptionByDefault\": {\"SSEAlgorithm\": \"AES256\"}}]}"
    # Enable versioning
    aws s3api put-bucket-versioning \
      --bucket ${BUCKET_NAME} \
      --versioning-configuration Status=Enabled
else
  exit 1
fi

exit 

# EOF
