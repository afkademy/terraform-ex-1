@Library("afkademy-sharedlib")

pipeline{
    agent { label 'linux' }
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
                    functioins.setParams() // function
                }
            }   
        }

        stage("Build Infrastructure"){
            when { equals expected: 'build', actual: params.action }
            steps{
                script{
                    withAWS([credentials:"${params.creds}",region: "${params.region}"]){
                        functions.terraformInit()
                        functions.terraformPlan()
                        functions.terraformApply()
                    }
                }
            }
        }
        stage("Destroy Infrastructure"){
            when { equals expected: 'destroy', actual: params.action }
            steps{
                script{
                    withAWS([credentials:"${params.creds}",region: "${params.region}"]){
                    functions.terraformInit()
                    functions.terraformPlan()  
                    functioins.terraformDestroy()
                    }
                }
            }
        }
    }
}