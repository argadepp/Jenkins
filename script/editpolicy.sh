#!/bin/bash
serviceRole=$1
instanceRole=$2
id=$3
accountNumber=$4
echo $PWD
ex=$(aws kms get-key-policy --key-id  $id --policy-name default --output text > $PWD/policy.json)
check=$(cat $PWD/policy.json | grep "arn:aws:iam::${accountNumber}:role/$instRole" | grep "arn:aws:iam::${accountNumber}:role/$serviceRole")

echo "$?"
echo $check
if [ $? -eq 0 ]
then
  echo $PWD
  inst=$(jq  '.Statement[1].Principal.AWS[]' $PWD/policy.json)
  echo $inst
  instRole="arn:aws:iam::${accountNumber}:role/$instanceRole"
  serviceRole="arn:aws:iam::${accountNumber}:role/$serviceRole"
  #perm=$(chmod 760 $PWD/*)
  newinst=$(jq '.Statement[2].Principal.AWS[.Statement[2].Principal.AWS | length] |= . + "'$instRole'"'  $PWD/policy.json > $PWD/new.json)

  service=$(jq '.Statement[2].Principal.AWS[.Statement[2].Principal.AWS | length] |= . + "'$serviceRole'"'  $PWD/new.json > $PWD/final.json)

  newinst=$(jq '.Statement[3].Principal.AWS[.Statement[3].Principal.AWS | length] |= . + "'$instRole'"'  $PWD/final.json > $PWD/new.json )

  service=$(jq '.Statement[3].Principal.AWS[.Statement[3].Principal.AWS | length] |= . + "'$serviceRole'"'  $PWD/new.json > $PWD/policy.json)
  changePolicy=$(aws kms put-key-policy --key-id  $id --policy-name default --policy file://$PWD/policy.json)
  
  echo $changePolicy
else
    echo "already present !!!!!!!!!!!"
fi
