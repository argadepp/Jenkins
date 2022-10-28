#!/bin/bash
instRole=$1
serviceRole=$2
id=$3
check=$(cat policy.json | grep "arn:aws:iam::895321766589:user/$instRole" | grep "arn:aws:iam::895321766589:user/$serviceRole")

echo "$?"
echo $check
if [ $? -eq 0 ]
then
  echo $PWD
  inst=$(jq  '.Statement[1].Principal.AWS[]' $PWD/policy.json)
  echo $inst
  instRole="arn:aws:iam::895321766589:role/$instRole"
  serviceRole="arn:aws:iam::895321766589:role/$serviceRole"
  newinst=$(jq '.Statement[2].Principal.AWS[.Statement[2].Principal.AWS | length] |= . + "'$instRole'"'  $PWD/policy.json > $PWD/new.json)

  service=$(jq '.Statement[2].Principal.AWS[.Statement[2].Principal.AWS | length] |= . + "'$serviceRole'"'  $PWD/new.json > $PWD/final.json)

  newinst=$(jq '.Statement[3].Principal.AWS[.Statement[3].Principal.AWS | length] |= . + "'$instRole'"'  $PWD/final.json > $PWD/new.json )

  service=$(jq '.Statement[3].Principal.AWS[.Statement[3].Principal.AWS | length] |= . + "'$serviceRole'"'  $PWD/new.json > $PWD/policy.json)
  changePolicy=$(aws kms get-key-policy --key-id  $id --policy-name default --output text > $PWD/policy.json)
else
    echo "already present !!!!!!!!!!!"
fi
