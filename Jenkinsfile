pipeline {
    agent any
    
    tools { 
        maven 'Maven3' 
    }

    environment {
        NEXUS_CRED_ID     = 'nexus-auth'
        MAVEN_SETTINGS_ID = 'caprivax-maven-settings'
        SONAR_PROJECT_KEY = 'java-webapp'
        SSH_CRED_ID       = 'target-vm-ssh'
        SLACK_CRED_ID     = 'slack-token'
        SLACK_CHANNEL     = 'C09PEC2E03A' 
        APP_VERSION       = "1.0.${env.BUILD_ID}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
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
                    // This is where your Ansible or SCP commands go
                    echo "SSH Agent is working! Ready to deploy version ${APP_VERSION}"
                }
            }
        }
    }

    post {
        success {
            slackSend(
                botUser: true,
                tokenCredentialId: "${SLACK_CRED_ID}",
                channel: "${SLACK_CHANNEL}",
                color: 'good',
                message: "✅ *CI/CD SUCCESS*: Build #${env.BUILD_NUMBER} for ${env.JOB_NAME} is complete."
            )
        }
        failure {
            slackSend(
                botUser: true,
                tokenCredentialId: "${SLACK_CRED_ID}",
                channel: "${SLACK_CHANNEL}",
                color: 'danger',
                message: "❌ *CI/CD FAILURE*: Build #${env.BUILD_NUMBER} failed. Check logs: ${env.BUILD_URL}"
            )
        }
        always {
            cleanWs()
        }
    }
}
