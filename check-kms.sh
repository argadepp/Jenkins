#!/bin/bash

opt = aws kms describe-key --key-id alias/eks-ebs-encrypt-key | grep arn | awk '{print $2}' | tr '",' ' '

echo $opt

