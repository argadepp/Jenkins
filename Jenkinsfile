pipeline {
    agent any
    environment {
        aws_region = "${params.aws_region}"
        
    }
    parameters {
        
       
         booleanParam(name: 'Refresh', defaultValue: false , description: 'Refresh this Job')
         choice(name: 'action' ,  choices: ['create','update'] , description: 'action regarding thr stack create or update , choose as per the requirment' )
         choice(name: 'environment', choices: ['dev', 'qa','prod'], description: '')
         choice(name: 'Product',choices: ['travel', 'pci','client'], description: '')
         string(name: 'aws_region', defaultValue: 'ap-south-1' , description: 'AWS Region' )
         string(name: 'stackName',defaultValue: 'asg')
         string(name: 'kmsKey' , defaultValue: 'eks-ebs-encrypt-key')
         string(name: 'templateUrl',defaultValue: 'https://cf-templates-g2cqbboygucc-ap-south-1.s3.ap-south-1.amazonaws.com/asg.yaml')
    }  
    stages {
   

        
     stage('Initialize AWS credentials') {
        steps {
        sh 'chmod +x ${WORKSPACE}/script/assume_deploy_role.sh'    
        sh(script:'${WORKSPACE}/script/assume_deploy_role.sh', label: 'Get the assume role credentials')
//         script {
//             def assumeRoleOutputFile = "${WORKSPACE}/assume-role-output.json"
//             env.AWS_ACCESS_KEY_ID = getCommandOutput("jq -r '.Credentials.AccessKeyId' ${assumeRoleOutputFile}", 'Get AccessKeyId')
//             env.AWS_SECRET_ACCESS_KEY = getCommandOutput("jq -r '.Credentials.SecretAccessKey' ${assumeRoleOutputFile}", 'Get SecretAccessKey')
//             //env.AWS_SESSION_TOKEN = getCommandOutput("jq -r '.Credentials.SessionToken' ${assumeRoleOutputFile}", 'Get SessionToken')
//             sh(script: 'aws sts get-caller-identity', label: 'STS GetCallerIdentity')
//         }
        }
    }
        
        stage('Check-Kms') {
            steps {
                 
                       
              withAWS(credentials: 'AWSCred' , region: 'ap-south-1') {
                  script { def ClusterName = "eks-${Product}-${environment}"
                        echo "${ClusterName}"
                    def instanceRole = "${ClusterName}-instance-role"  
                        echo "${instanceRole}"
                        def serviceRole = "${ClusterName}-service-role" 
                        echo "${serviceRole}"
              sh 'chmod +x ${WORKSPACE}/script/iamRoleCheck.sh'
                          sh(script: "${WORKSPACE}/script/iamRoleCheck.sh ${serviceRole} ${instanceRole} ${ClusterName} ")    
              sh 'chmod +x ${WORKSPACE}/script/check-kms.sh'
                  sh(script: "${WORKSPACE}/script/check-kms.sh ${kmsKey} ${serviceRole} ${instanceRole}")
                         }
              }
            }
        }
    }
}
