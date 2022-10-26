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
   

        
        stage('Check-Kms') {
            steps {
                script { def ClusterName = "eks-${Product}-${Environment}"
                        echo "${ClusterName}"
                    def instanceRole = "${ClusterName}-${Product}-${Environment}-instance-role"  
                        echo "${instanceRole}"
                        def serviceRole = "${ClusterName}-${Product}-${Environment}-service-role" 
                        echo "${serviceRole}"
                       }
              withAWS(credentials: 'AWSCred' , region: 'ap-south-1') {
              sh 'chmod +x ${WORKSPACE}/script/check-kms.sh'
                  sh(script: "${WORKSPACE}/script/iamRoleCheck.sh ${serviceRole} ${instanceRole}")    
              sh 'chmod +x ${WORKSPACE}/script/check-kms.sh'
                  sh(script: "${WORKSPACE}/script/iamRoleCheck.sh ${kmsKey}")
              }
            }
        }
    }
}
