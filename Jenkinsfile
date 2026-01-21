pipeline {
    agent any
    
    environment {
        // Use the exact ID you saved in Jenkins Credentials
        SLACK_CRED_ID = 'slack-token'
        // Use the verified Channel ID (C09PEC2E03A)
        SLACK_CHANNEL = 'C09PEC2E03A'
    }

    stages {
        stage('Health Check') {
            steps {
                echo "Testing Slack connectivity for lois-devops..."
                sh "date"
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
                message: "✅ *FEEDBACK LOOP STABILIZED*\nProject: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}\nStatus: The Slack integration is working perfectly."
            )
        }
        failure {
            slackSend(
                botUser: true,
                tokenCredentialId: "${SLACK_CRED_ID}",
                channel: "${SLACK_CHANNEL}",
                color: 'danger',
                message: "❌ *SLACK TEST FAILED*\nCheck the Jenkins console logs for credential errors."
            )
        }
    }
}
