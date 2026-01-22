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
        APP_VERSION       = "1.0.${env.BUILD_ID}"
        SLACK_CHANNEL_ID  = 'C09PEC2E03A'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test Slack') {
            steps {
                script {
                    echo "Testing Slack with channel ID: ${SLACK_CHANNEL_ID}"
                }
            }
        }
    }

    post {
        always {
            script {
                slackSend(
                    channel: "${SLACK_CHANNEL_ID}",
                    color: 'good',
                    message: "✅ TEST: Jenkinsfile update successful! Channel ID: ${SLACK_CHANNEL_ID}"
                )
            }
        }
    }
}
