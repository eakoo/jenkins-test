pipeline{

    agent any

    tools{
        maven 'M3'
    }

    environment{
        serverName = '192.168.0.102'
        uploadFile = false
    }

    stages{

        stage("Chose") {
            steps {
                timeout(time: 10, unit: 'SECONDS') {
                    script {
                        try {
                            uploadFile = input message: 'Upload file?', ok: '确认',
                            parameters: [
                                booleanParam(
                                    name: 'uploadFile',
                                    defaultValue: false
                                )
                            ]
                        } catch (exc) {
                            echo "select default"
                        }
                    }
                }
            }
        }

        stage('Build'){
            steps{
                echo "${uploadFile}"
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Upload'){
            when {
                expression {
                   return  (uploadFile == true)
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
                                    ''',
                                    execTimeout: 120000,
                                    flatten: false,
                                    makeEmptyDirs: false,
                                    noDefaultExcludes: false,
                                    patternSeparator: '[, ]+',
                                    remoteDirectory: "",
                                    remoteDirectorySDF: false,
                                    removePrefix: "target/deploy/",
                                    sourceFiles: "target/deploy *//*"
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
