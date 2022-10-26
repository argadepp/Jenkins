#!/bin/bash
roleName=$1
instanceRole=$2
echo "Checking IAM Roles"
myCmd=(aws iam get-role --role-name $roleName)
instCheck=(aws iam get-role --role-name $instanceRole)
if ("${myCmd[@]}" > myJson.file 2> error.file) & ("${instCheck[@]}" > myJson1.file 2> error.file;) then
   echo "!!!Present!!!"
   arn=$(cat $PWD/myJson.file | grep arn | awk '{print $2}' | tr '",' ' ')
   echo "Service Role Arn=$arn"
   echo "!!!Present!!!"
   arn1=$(cat $PWD/myJson1.file | grep arn | awk '{print $2}' | tr '",' ' ') 
   echo "InstanceRole Arn=$arn1"  
else
    err="$(cat error.file)"
    echo "It's not present , creation is initiated !!!!!!!!!"
    templateUrl="file://${WORKSPACE}/template/iamRoles.yaml"
  
    echo "!!!!!!!!!!!!! ${action} of ${environment}-${stackName} stack is initiated !!!!!!!!!!!!!!!!!!!!!!!!"
    aws cloudformation "${action}"-stack \
    --template-body "${templateUrl}" --region "${aws_region}" \
    --stack-name "${environment}-${stackName}" --parameters ParameterKey=Product,ParameterValue="${Product}" ParameterKey=ClusterName,ParameterValue="${ClusterName}" ParameterKey=Environment,ParameterValue="${environment}" \
    --capabilities CAPABILITY_NAMED_IAM
    
    echo "Waiting for the '${action}' operation to complete on CloudFormation stack: ${environment}-${stackName}"
    aws cloudformation wait stack-${action}-complete \
    --stack-name ${environment}-${stackName} \
    --region ${aws_region}
    
    echo "${stackName} is created successfully !!!!!!!!!!!!!!!!"
    
    

fi    
