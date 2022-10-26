#!/bin/bash
id=$1

myCmd=(aws kms describe-key --key-id alias/$id)
if "${myCmd[@]}" > myJson.file 2> error.file; then
   echo "Present"
    arn=$(cat $PWD/myJson.file | grep arn | awk '{print $2}' | tr '",' ' ')
   echo "Arn=$arn"
else
    err="$(cat error.file)"
    echo "It's not present , creation is initiated !!!!!!!!!"

    templateUrl="file://${WORKSPACE}/kms.yaml"

    echo "!!!!!!!!!!!!! ${action} of ${environment}-${stackName} stack is initiated !!!!!!!!!!!!!!!!!!!!!!!!"
    aws cloudformation "${action}"-stack \
    --template-body "${templateUrl}" --region "${aws_region}" \
    --stack-name "${environment}-${stackName}" \
    --capabilities CAPABILITY_NAMED_IAM
    
    echo "Waiting for the '${action}' operation to complete on CloudFormation stack: ${environment}-${stackName}"
    aws cloudformation wait stack-${action}-complete \
    --stack-name ${environment}-${stackName} \
    --region ${aws_region}
    
    echo "${stackName} is created successfully !!!!!!!!!!!!!!!!" 
fi



