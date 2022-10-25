# #!/bin/bash
role="arn:aws:iam::895321766589:role/awspratik-admin-role"
aws sts assume-role \
    --role-arn ${role} \
    --role-session-name TemporarySessionKeys \
    --output json > assume-role-output.json
