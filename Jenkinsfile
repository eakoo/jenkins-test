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
                timeout(time: 3, unit: 'SECONDS') {
                    script {
                        try {
                            uploadFile = input message: 'update config?', ok: '确认',
                            parameters: [booleanParam(name: 'uploadFile', defaultValue: false, description: 'Upload file?')]
                        } catch (exc) {
                            echo "select default"
                        }
                    }
                }
                echo "${uploadFile}"
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
                environment name: 'uploadFile', value: 'true'
                /* expression {
                    uploadFile
                } */
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
