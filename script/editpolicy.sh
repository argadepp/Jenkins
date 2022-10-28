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
  inst=$(jq  '.Statement[1].Principal.AWS[]' $PWD/script/policy.json)
  echo $inst
  instRole="arn:aws:iam::895321766589:role/$instRole"
  serviceRole="arn:aws:iam::895321766589:role/$serviceRole"
  #perm=$(chmod 760 $PWD/script/*)
  newinst=$(jq '.Statement[2].Principal.AWS[.Statement[2].Principal.AWS | length] |= . + "'$instRole'"'  $PWD/script/policy.json > $PWD/script/new.json)

  service=$(jq '.Statement[2].Principal.AWS[.Statement[2].Principal.AWS | length] |= . + "'$serviceRole'"'  $PWD/script/new.json > $PWD/script/final.json)

  newinst=$(jq '.Statement[3].Principal.AWS[.Statement[3].Principal.AWS | length] |= . + "'$instRole'"'  $PWD/script/final.json > $PWD/script/new.json )

  service=$(jq '.Statement[3].Principal.AWS[.Statement[3].Principal.AWS | length] |= . + "'$serviceRole'"'  $PWD/script/new.json > $PWD/script/policy.json)
  changePolicy=$(aws kms get-key-policy --key-id  $id --policy-name default --output text > file://$PWD/script/policy.json)
else
    echo "already present !!!!!!!!!!!"
fi
