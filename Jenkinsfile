pipeline {
    agent any
    environment {
        APP_VERSION = "1.0.${env.BUILD_ID}"
        // Use the ID here for maximum reliability
        SLACK_CHANNEL = 'C09PEC2E03A'
    }
    stages {
        stage('Checkout') { steps { checkout scm } }
        // ... (other stages)
    }
    post {
        success {
            slackSend(
                botUser: true,
                tokenCredentialId: 'slack-token',
                channel: "${SLACK_CHANNEL}",
                color: 'good',
                message: "✅ *CI SUCCESS*: ${env.JOB_NAME} [${env.BUILD_NUMBER}]"
            )
        }
        failure {
            slackSend(
                botUser: true,
                tokenCredentialId: 'slack-token',
                channel: "${SLACK_CHANNEL}",
                color: 'danger',
                message: "❌ *CI FAILURE*: ${env.JOB_NAME} [${env.BUILD_NUMBER}]"
            )
        }
    }
}
