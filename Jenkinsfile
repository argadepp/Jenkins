pipeline {
    agent any
    environment {
        aws_region = "${params.aws_region}"
        
    }
    parameters {
        
       
         booleanParam(name: 'Refresh', defaultValue: false , description: 'Refresh this Job')
         choice(name: 'action' ,  choices: ['create','update'] , description: 'action regarding thr stack create or update , choose as per the requirment' )
         choice(name: 'environment', choices: ['dev', 'qa','prod'], description: '')
         string(name: 'aws_region', defaultValue: 'ap-south-1' , description: 'AWS Region' )
         string(name: 'stackName',defaultValue: 'asg')
         string(name: 'VPC' , defaultValue: 'vpc-5a0ff131' , description: 'Pass the VPC ID ' )
         string(name: 'Subnets' , defaultValue: 'subnet-be0798c5')
         string(name: 'LBSubnets' , defaultValue: 'subnet-7e36d115')
         string(name: 'AmiId' , defaultValue: 'ami-024c319d5d14b463e')
         choice(name: 'InstanceType' , choices: ['t3.micro','t3.small','t3.medium'])
         string(name: 'DNS' , description: 'Enter DNS name ')
         string(name: 'Alias' , description: 'Alias for LB')
         string(name: 'templateUrl',defaultValue: 'https://cf-templates-g2cqbboygucc-ap-south-1.s3.ap-south-1.amazonaws.com/asg.yaml')
    }  
    stages {
   

        
        stage('Check-Kms') {
            steps {
              withAWS(credentials: 'AWSCred' , region: 'ap-south-1') {
              sh 'chmod +x ${WORKSPACE}/check-kms.sh'
              sh(script: "${WORKSPACE}/check-kms.sh")
              }
            }
        }
    }
}
