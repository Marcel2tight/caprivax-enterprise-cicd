pipeline {
    agent any
    
    environment {
        SLACK_CRED_ID = 'slack-token'
        // Using the permanent ID for #all-lois-devops
        SLACK_CHANNEL = 'C09PEC2E03A' 
    }

    stages {
        stage('Connectivity Test') {
            steps {
                echo "Isolating Slack notification test..."
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
                message: "íº€ *Feedback Loop Active*\nChannel: #all-lois-devops\nBuild: #${env.BUILD_NUMBER}\nStatus: ${currentBuild.currentResult}"
            )
        }
    }
}
