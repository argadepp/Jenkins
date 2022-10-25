#!/bin/bash
templateUrl="file://${WORKSPACE}/template/kms.yaml"

aws '${action}'-stack --stack-name '${stackName}' --template-body "${templateUrl}" --capabilities CAPABILITY_NAMED_IAM
