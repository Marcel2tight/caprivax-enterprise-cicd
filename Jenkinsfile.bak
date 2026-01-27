pipeline {
    agent any
    
    tools { 
        maven 'Maven3' 
    }

    environment {
        // IDs must match your Jenkins Credentials and Managed Files exactly
        NEXUS_CRED_ID     = 'nexus-auth'
        MAVEN_SETTINGS_ID = 'caprivax-maven-settings'
        SONAR_PROJECT_KEY = 'java-webapp'
        SSH_CRED_ID       = 'target-vm-ssh'
        // Dynamic versioning: Uses Jenkins Build ID to ensure unique artifacts
        APP_VERSION       = "1.0.${env.BUILD_ID}"
        // Slack channel ID instead of name
        SLACK_CHANNEL_ID  = 'C09PEC2E03A'
    }

    stages {
        stage('Validate Setup') {
            steps {
                script {
                    // Test if SSH credentials exist
                    echo "Validating SSH credentials: ${SSH_CRED_ID}"
                    try {
                        withCredentials([sshUserPrivateKey(
                            credentialsId: "${SSH_CRED_ID}",
                            keyFileVariable: 'SSH_KEY',
                            usernameVariable: 'SSH_USER'
                        )]) {
                            sh '''
                                echo "‚úÖ SSH credentials validated successfully"
                                echo "SSH User: $SSH_USER"
                                ls -la $SSH_KEY
                            '''
                        }
                    } catch (Exception e) {
                        error "‚ùå SSH credentials '${SSH_CRED_ID}' not found or invalid. Please check Jenkins Credentials."
                    }
                    
                    echo "‚úÖ Setup validation completed"
                }
            }
        }
        
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Quality Scan') {
            steps {
                configFileProvider([configFile(fileId: "${MAVEN_SETTINGS_ID}", variable: 'MAVEN_SETTINGS')]) {
                    withCredentials([usernamePassword(credentialsId: "${NEXUS_CRED_ID}", passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                        withSonarQubeEnv('SonarQube') {
                            sh "mvn -s $MAVEN_SETTINGS -f smartops-backend/pom.xml clean verify \
                                org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
                                -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                                -Drevision=${APP_VERSION}"
                        }
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 15, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build & Deploy to Nexus') {
            steps {
                configFileProvider([configFile(fileId: "${MAVEN_SETTINGS_ID}", variable: 'MAVEN_SETTINGS')]) {
                    withCredentials([usernamePassword(credentialsId: "${NEXUS_CRED_ID}", passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                        sh "mvn -s $MAVEN_SETTINGS -f smartops-backend/pom.xml deploy -DskipTests -Drevision=${APP_VERSION}"
                    }
                }
            }
        }

        stage('Deploy to Dev') {
            steps {
                sshagent(["${SSH_CRED_ID}"]) {
                    withCredentials([usernamePassword(credentialsId: "${NEXUS_CRED_ID}", passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                        sh "ansible-playbook -i ansible/inventory/dev.ini ansible/deploy.yml \
                            -e 'app_version=${APP_VERSION} nexus_pwd=${NEXUS_PWD}'"
                    }
                }
            }
        }

        stage('Promote to Production') {
            steps {
                input message: "Approve deployment to PRODUCTION?", ok: "Deploy Now"
                
                sshagent(["${SSH_CRED_ID}"]) {
                    withCredentials([usernamePassword(credentialsId: "${NEXUS_CRED_ID}", passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                        sh "ansible-playbook -i ansible/inventory/prod.ini ansible/deploy.yml \
                            -e 'app_version=${APP_VERSION} nexus_pwd=${NEXUS_PWD}'"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                def slackMessage = "Build #${env.BUILD_NUMBER} of ${env.JOB_NAME} - Status: ${currentBuild.currentResult} \nDetails: ${env.BUILD_URL}"
                def slackColor = (currentBuild.currentResult == 'SUCCESS') ? 'good' : 'danger'
                
                try {
                    slackSend(
                        channel: "${SLACK_CHANNEL_ID}",
                        color: slackColor,
                        message: slackMessage
                    )
                    echo "‚úÖ Slack notification sent to channel ID: ${SLACK_CHANNEL_ID}"
                } catch (Exception e) {
                    echo "‚ö†Ô∏è  Slack notification failed: ${e.message}"
                    
                    try {
                        slackSend(
                            channel: '#jenkins-builds',
                            color: 'warning',
                            message: "‚ö†Ô∏è Build #${env.BUILD_NUMBER} - ${env.JOB_NAME} - Status: ${currentBuild.currentResult} \nPrimary Slack channel failed. Check Jenkins logs."
                        )
                    } catch (Exception e2) {
                        echo "‚ùå Both Slack notification methods failed"
                    }
                }
            }
        }
        
        failure {
            script {
                try {
                    slackSend(
                        channel: "${SLACK_CHANNEL_ID}",
                        color: 'danger',
                        message: "Ì∫® BUILD FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}\nStatus: ${currentBuild.currentResult}\nLogs: ${env.BUILD_URL}"
                    )
                } catch (Exception e) {
                    echo "Failed to send failure notification: ${e.message}"
                }
            }
        }
        
        success {
            script {
                try {
                    slackSend(
                        channel: "${SLACK_CHANNEL_ID}",
                        color: 'good',
                        message: "Ìæâ BUILD SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}\nAll stages completed successfully!\nView: ${env.BUILD_URL}"
                    )
                } catch (Exception e) {
                    echo "Failed to send success notification: ${e.message}"
                }
            }
        }
        
        changed {
            script {
                if (currentBuild.currentResult == 'SUCCESS' && currentBuild.previousBuild?.result != 'SUCCESS') {
                    try {
                        slackSend(
                            channel: "${SLACK_CHANNEL_ID}",
                            color: 'good',
                            message: "Ì¥Ñ RECOVERY: ${env.JOB_NAME} #${env.BUILD_NUMBER}\nBuild recovered from previous failure!\nView: ${env.BUILD_URL}"
                        )
                    } catch (Exception e) {
                        echo "Failed to send recovery notification: ${e.message}"
                    }
                }
            }
        }
    }
}
