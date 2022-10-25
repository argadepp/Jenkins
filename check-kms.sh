#!/bin/bash
templateUrl="file://${WORKSPACE}/kms.yaml"

echo "!!!!!!!!!!!!! ${action} of ${environment}-${stackName} stack is initiated !!!!!!!!!!!!!!!!!!!!!!!!"
aws cloudformation "${action}"-stack \
--template-body "${templateUrl}" --region "${aws_region}" \
--stack-name "${environment}-${stackName}" \
--capabilities CAPABILITY_NAMED_IAM
