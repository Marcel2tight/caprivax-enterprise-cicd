pipeline {
    agent any
    
    environment {
        SLACK_CRED_ID = 'slack-token'
        // This is the specific ID for #all-lois-devops
        SLACK_CHANNEL = 'C09PEC2E03A' 
    }

    stages {
        stage('Slack Loop Test') {
            steps {
                echo "Testing ONLY Slack notifications..."
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
                message: "íº€ *SLACK IS WORKING*\nChannel: #all-lois-devops\nBuild: #${env.BUILD_NUMBER}"
            )
        }
    }
}
