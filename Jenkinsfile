pipeline{

    agent any

    tools{
        maven 'M3' // M3 要与Jenkins 全局maven配置的名称一样或者改成全路径也可以
        // maven '/usr/local/apache-maven-3.8.4'
    }

    environment{
        target = 'target/'
        jarName = 'target/jenkins-test-1.0.0.jar'  // Publish over SSH 推送的 sourceFiles
        uploadFile = false
        serverName = '192.168.0.102'    // Publish over SSH 配置的name
        deployPath = '/usr/local/jenkins-test'    // Publish over SSH 配置的目录
        shellPath = 'target/deploy/'    // mvn package 打包之后配置文件目录
    }

    stages{

        stage("Chose") {
            steps {
                timeout(time: 10, unit: 'SECONDS') {
                    script {
                        try {
                            uploadFile = input message: 'Upload Deploy File?', ok: '确认',
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
                                                cd ''' + deployPath + '''
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
                                            removePrefix: target,
                                            sourceFiles: jarName
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
                                            removePrefix: shellPath,
                                            sourceFiles: shellPath + '*'
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
