#!/bin/bash

role="arn:aws:iam::895321766589:role/awspratik-admin-role"

# echo "Assuming '${role}' with extra arguments: "
# aws sts assume-role \
#     --role-arn ${role} \
#     --role-session-name TemporarySessionKeys \
#     --output json > assume-role-output1.json

access_key=$(cat /root/.aws/credentials | grep aws_access_key_id | awk '{print $3}')
secret_key=$(cat /root/.aws/credentials | grep aws_secret_access_key | awk '{print $3}')

aws configure aws_access_key_id $access_key aws_secret_access_key $secret_key

aws s3 ls
