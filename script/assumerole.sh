#!/bin/bash

role="arn:aws:iam::895321766589:role/test-role"

echo "Assuming '${role}' with extra arguments: "
aws sts assume-role \
    --role-arn ${role} \
    --role-session-name TemporarySessionKeys \
    --output json  > assume-role-output.json
