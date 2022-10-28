#!/bin/bash
instRole=$1
serviceRole=$2

check=$(cat policy.json | grep "arn:aws:iam::895321766589:user/$instRole" | grep "arn:aws:iam::895321766589:user/$serviceRole")

echo "$?"
echo $check
if [ $? -eq 0 ]
then
  inst=$(jq  '.Statement[1].Principal.AWS[]' policy.json)
  #echo $inst
  instRole="arn:aws:iam::895321766589:role/$instRole"
  serviceRole="arn:aws:iam::895321766589:role/$serviceRole"
  newinst=$(jq '.Statement[2].Principal.AWS[.Statement[2].Principal.AWS | length] |= . + "'$instRole'"'  policy.json > new.json)

  service=$(jq '.Statement[2].Principal.AWS[.Statement[2].Principal.AWS | length] |= . + "'$serviceRole'"'  new.json > final.json)

  newinst=$(jq '.Statement[3].Principal.AWS[.Statement[3].Principal.AWS | length] |= . + "'$instRole'"'  final.json > new.json )

  service=$(jq '.Statement[3].Principal.AWS[.Statement[3].Principal.AWS | length] |= . + "'$serviceRole'"'  new.json > policy.json)
else
    echo "already present !!!!!!!!!!!"
fi
