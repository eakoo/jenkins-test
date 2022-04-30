pipeline{
    agent any

    tools{
        maven 'M3'
    }

    environment{
        branch = 'main'
        serverName = '192.168.0.102'
        skipUploadFile = false
    }

    stages{

        stage('Clone'){
            steps{
                git(changelog: true, url: "https://gitee.com/original-blackhole/jenkins-test.git", branch: branch)
            }
        }

        stage('Build'){
            steps{
                sh 'mvn clean package -DskipTests'
            }
        }
    }

}