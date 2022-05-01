pipeline{

    agent any

    tools{
        maven 'M3'
    }

    environment{
        appName = 'jenkins-test'
        jarName = '${appName}-1.0.0.jar'
        uploadFile = false
        serverName = '192.168.0.102'
        deployPath = '/usr/local/${appName}'
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

        stage('Parallel Deploy'){
            failFast true
            parallel {
                stage('Deploy') {
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
                                                cd ${deployPath}
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
                                            sourceFiles: "target/${jarName}"
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

                stage('Upload') {
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
            }
        }
    }
}
