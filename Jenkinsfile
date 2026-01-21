pipeline {
    agent any
    
    environment {
        SLACK_CRED_ID = 'slack-token'
        // Using the ID for #all-lois-devops to ensure it's found
        SLACK_CHANNEL = 'C09PEC2E03A'
    }

    stages {
        stage('Slack Connectivity Test') {
            steps {
                echo "Testing notification for #all-lois-devops..."
            }
        }
    }

    post {
        always {
            slackSend(
                botUser: true,
                tokenCredentialId: "${SLACK_CRED_ID}",
                channel: "${SLACK_CHANNEL}",
                color: (currentBuild.currentResult == 'SUCCESS') ? 'good' : 'danger',
                message: "íº€ *Notification System Active*\nChannel: #all-lois-devops\nBuild: #${env.BUILD_NUMBER}\nResult: ${currentBuild.currentResult}"
            )
        }
    }
}
