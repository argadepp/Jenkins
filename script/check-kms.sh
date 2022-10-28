#!/bin/bash
id=$1
roleName=$2
instanceRole=$3

######### Check IAM ##################
myCmd=(aws iam get-role --role-name $roleName)
instCheck=(aws iam get-role --role-name $instanceRole)

"${myCmd[@]}" > myJson.file
arn=$(cat $PWD/myJson.file | grep arn | awk '{print $2}' | tr '",' ' ')
echo "Service Role Arn=$arn"

"${instCheck[@]}" > myJson1.file
 arn1=$(cat $PWD/myJson.file | grep arn | awk '{print $2}' | tr '",' ' ') 
 echo "InstanceRole Arn=$arn1"
######################################
myCmd1=(aws kms describe-key --key-id alias/$id)
if "${myCmd1[@]}" > myJson.file 2> error.file; then
   echo "Present"
    arn=$(cat $PWD/myJson.file | grep arn | awk '{print $2}' | tr '",' ' ')
   echo "Arn=$arn"

    sh $PWD/script/editpolicy.sh $roleName $instanceRole $id
else
    err="$(cat error.file)"
    echo "It's not present , creation is initiated !!!!!!!!!"

    templateUrl="file://${WORKSPACE}/template/kms.yaml"

    echo "!!!!!!!!!!!!! ${action} of ${environment}-${stackName} stack is initiated !!!!!!!!!!!!!!!!!!!!!!!!"
    aws cloudformation "${action}"-stack \
    --template-body "${templateUrl}" --region "${aws_region}" \
    --stack-name "eks-kms-${environment}-${stackName}"  --parameters ParameterKey=ServiceRole,ParameterValue="${arn}" ParameterKey=InstanceRole,ParameterValue="${arn1}" \
    --capabilities CAPABILITY_NAMED_IAM
    
    echo "Waiting for the '${action}' operation to complete on CloudFormation stack: ${environment}-${stackName}"
    aws cloudformation wait stack-${action}-complete \
    --stack-name "eks-kms-${environment}-${stackName}" \
    --region ${aws_region}
    
    echo "${stackName} is created successfully !!!!!!!!!!!!!!!!" 
fi

