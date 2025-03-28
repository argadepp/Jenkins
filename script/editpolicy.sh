#!/bin/bash
serviceRole=$1
instanceRole=$2
id=$3
accountNumber=$4
echo $PWD
ex=$(aws kms get-key-policy --key-id  $id --policy-name default --output text > kmspolicy.json)
check=$(cat kmspolicy.json | grep "arn:aws:iam::${accountNumber}:role/$instRole" | grep "arn:aws:iam::${accountNumber}:role/$serviceRole")

echo "$?"
echo $check
if [ $? -eq 0 ]
then
  echo $PWD
  inst=$(jq  '.Statement[2].Principal.AWS[]' kmspolicy.json)
  echo $inst
  instRole="arn:aws:iam::${accountNumber}:role/$instanceRole"
  serviceRole="arn:aws:iam::${accountNumber}:role/$serviceRole"
  #perm=$(chmod 760 $PWD/*)
  newinst=$(jq '.Statement[2].Principal.AWS[.Statement[2].Principal.AWS | length] |= . + "'$instRole'"'  kmspolicy.json > new.json)

  service=$(jq '.Statement[2].Principal.AWS[.Statement[2].Principal.AWS | length] |= . + "'$serviceRole'"'  new.json > final.json)

  newinst=$(jq '.Statement[3].Principal.AWS[.Statement[3].Principal.AWS | length] |= . + "'$instRole'"'  final.json > new.json )

  service=$(jq '.Statement[3].Principal.AWS[.Statement[3].Principal.AWS | length] |= . + "'$serviceRole'"'  new.json > policy.json)
  changePolicy=$(aws kms put-key-policy --key-id  $id --policy-name default --policy file://policy.json)
  
  echo $changePolicy
  
  if [ $? -eq 0 ]
  then
    echo "Succesfully updated !!!!!!!!!!!!!"
    
  fi  
else
    echo "already present !!!!!!!!!!!"
fi
