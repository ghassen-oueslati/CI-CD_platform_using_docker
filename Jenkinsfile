pipeline {
    agent any
    environment {
        PATH = "/usr/bin/mvn:$PATH"
        }   
    stages 
    {
        stage("clone code")
        {
            steps
                {
                git branch: 'main',credentialsId: 'be415b2c-6347-48a4-a24b-6cc743c73672', url: 'http://172.18.0.3/root/java-helloworld.git'
                }
        }
        stage("build code")
        {
            steps{
                sh "mvn clean install"
            }
        }
    }

    post
    {
        always 
        {
            archiveArtifacts artifacts: 'build/libs/**/*.jar', fingerprint: true
            junit 'build/reports/**/*.xml'
        }
    }
}
