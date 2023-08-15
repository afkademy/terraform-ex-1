pipeline{
    agent { label 'dynamic-agents' }
    parameters{
        choice(name: 'action', choices: ['build', 'destroy'], description: 'Build Or Destroy Infrastructure')
        string(name: 'environment', defaultValue: 'default', description: 'Environment name')
        string(name: 'team', defaultValue: 'default', description: 'Team name')
        string(name: 'region', defaultValue: 'us-east-1', description: 'region')
        string(name: 'azs', defaultValue: '', description: 'availability zones')
        string(name: 'creds', defaultValue: '', description: 'credentials id')
        string(name: 'cidr', defaultValue: '', description: 'vpc cidr')
        string(name: 'public_cidr', defaultValue: '', description: 'public cidrs')
        string(name: 'private_cidr', defaultValue: '', description: 'private cidrs')
        string(name: 'bucket', defaultValue: '', description: 'bucket name')
    }
    stages{
        stage("init build params"){
            steps{
                script{
                    setParams() // function
                }
            }   
        }

        stage("Build Infrastructure"){
            when { equals expected: 'build', actual: params.action }
            steps{
                script{
                    withAWS([credentials:"${params.creds}",region: "${params.region}"]){
                        terraformInit()
                        sh"""
                        terraform plan -no-color -var-file $WORKSPACE/vars/terraform.tfvars
                        terraform apply  -var-file $WORKSPACE/vars/terraform.tfvars -no-color -auto-approve
                        """
                    }
                }
            }
        }
        stage("Destroy Infrastructure"){
            when { equals expected: 'destroy', actual: params.action }
            steps{
                script{
                    withAWS([credentials:"${params.creds}",region: "${params.region}"]){
                    terraformInit()    
                    sh"""
                    terraform plan -no-color -var-file $WORKSPACE/vars/terraform.tfvars
                    terraform destroy -var-file $WORKSPACE/vars/terraform.tfvars -no-color -auto-approve 
                    """
                    }
                }
            }
        }
    }
}

void setParams(){
    sh"sed -i 's/ENV/${params.environment}/g' $WORKSPACE/vars/terraform.tfvars"
    sh"sed -i 's/TEAM/${params.team}/g' $WORKSPACE/vars/terraform.tfvars"
    sh"sed -i 's/REGION/${params.region}/g' $WORKSPACE/vars/terraform.tfvars"
    sh"sed -i 's#CIDR#${params.cidr}#g' $WORKSPACE/vars/terraform.tfvars"
    sh"sed -i 's#PUBLIC#${params.public_cidr}#g' $WORKSPACE/vars/terraform.tfvars"
    sh"sed -i 's#PRIVATE#${params.private_cidr}#g' $WORKSPACE/vars/terraform.tfvars"
    sh"sed -i 's#AZS#${params.azs}#g' $WORKSPACE/vars/terraform.tfvars"
    sh"sed -i 's/BUCKET/${params.bucket}/g' $WORKSPACE/vars/terraform.tfvars"
    sh"sed -i 's/REGION/${params.region}/g' $WORKSPACE/provider.tf"
    sh"cat $WORKSPACE/vars/terraform.tfvars"
}

void terraformInit(){
    def tfworkspace = "${params.environment}-${params.team}"
    sh"""
    terraform init -no-color
    terraform workspace select -no-color ${tfworkspace} || terraform workspace new -no-color ${tfworkspace}
    terraform workspace show -no-color
    terraform validate -no-color
    """
}