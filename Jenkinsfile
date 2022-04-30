pipeline{

    agent any

    tools{
        maven 'M3'
    }

    environment{
        serverName = '192.168.0.102'
        uploadFile = true
    }

    stages{

        stage('Build'){
            steps{
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Upload'){
            when {
                expression {
                    !uploadFile
                }
            }
            steps{
                sshPublisher(
                    failOnError: false,
                    publishers: [
                        sshPublisherDesc(
                            configName: serverName,
                            transfers: [
                                sshTransfer(
                                    cleanRemote: false,
                                    excludes: '',
                                    execCommand: '''
                                        sh chmod +x build.sh
                                        sh chmod +x restart.sh
                                    ''',
                                    execTimeout: 120000,
                                    flatten: false,
                                    makeEmptyDirs: false,
                                    noDefaultExcludes: false,
                                    patternSeparator: '[, ]+',
                                    remoteDirectory: "",
                                    remoteDirectorySDF: false,
                                    removePrefix: "target/deploy/",
                                    sourceFiles: "target/deploy/*"
                                )
                            ],
                            sshRetry: [
                                retries: 0
                            ],
                            usePromotionTimestamp: false,
                            useWorkspaceInPromotion: false,
                            verbose: true
                        )
                    ]
                )
            }
        }

        stage('Deploy'){
            steps{
                sshPublisher(
                    failOnError: false,
                    publishers: [
                        sshPublisherDesc(
                            configName: serverName,
                            transfers: [
                                sshTransfer(
                                    cleanRemote: false,
                                    excludes: '',
                                    execCommand: '''
                                        cd /usr/local/jenkins-test
                                        sh build.sh
                                        sh restart.sh
                                    ''',
                                    execTimeout: 120000,
                                    flatten: false,
                                    makeEmptyDirs: false,
                                    noDefaultExcludes: false,
                                    patternSeparator: '[, ]+',
                                    remoteDirectory: "",
                                    remoteDirectorySDF: false,
                                    removePrefix: "target/",
                                    sourceFiles: "target/jenkins-test-1.0.0.jar"
                                )
                            ],
                            sshRetry: [
                                retries: 0
                            ],
                            usePromotionTimestamp: false,
                            useWorkspaceInPromotion: false,
                            verbose: true
                        )
                    ]
                )
            }
        }

    }

}
