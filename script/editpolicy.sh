#!/bin/bash
serviceRole=$1
instanceRole=$2
id=$3
accountNumber=$4
echo $PWD
ex=$(aws kms get-key-policy --key-id  $id --policy-name default --output text > $PWD/policy.json)
check=$(cat $PWD/script/policy.json | grep "arn:aws:iam::${accountNumber}:role/$instRole" | grep "arn:aws:iam::${accountNumber}:role/$serviceRole")

echo "$?"
echo $check
if [ $? -eq 0 ]
then
  echo $PWD
  inst=$(jq  '.Statement[1].Principal.AWS[]' $PWD/script/policy.json)
  echo $inst
  instRole="arn:aws:iam::${accountNumber}:role/$instanceRole"
  serviceRole="arn:aws:iam::${accountNumber}:role/$serviceRole"
  #perm=$(chmod 760 $PWD/script/*)
  newinst=$(jq '.Statement[2].Principal.AWS[.Statement[2].Principal.AWS | length] |= . + "'$instRole'"'  $PWD/script/policy.json > $PWD/script/new.json)

  service=$(jq '.Statement[2].Principal.AWS[.Statement[2].Principal.AWS | length] |= . + "'$serviceRole'"'  $PWD/script/new.json > $PWD/script/final.json)

  newinst=$(jq '.Statement[3].Principal.AWS[.Statement[3].Principal.AWS | length] |= . + "'$instRole'"'  $PWD/script/final.json > $PWD/script/new.json )

  service=$(jq '.Statement[3].Principal.AWS[.Statement[3].Principal.AWS | length] |= . + "'$serviceRole'"'  $PWD/script/new.json > $PWD/script/policy.json)
  changePolicy=$(aws kms put-key-policy --key-id  $id --policy-name default --policy file://$PWD/script/policy.json)
  
  echo $changePolicy
else
    echo "already present !!!!!!!!!!!"
fi
