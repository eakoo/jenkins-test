pipeline{
    agent any

    tools{
        maven 'M3'
    }

    environment{
        branch = 'dev'
        serverName = '192.168.0.102'
        skipUploadFile = false
    }

    stages{

        stage('Build'){
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