pipeline {
    agent any
    stages {
        stage('Force Slack Test') {
            steps {
                // We use the ID C09PEC2E03A here as a string
                slackSend(
                    botUser: true,
                    tokenCredentialId: 'slack-token',
                    channel: 'C09PEC2E03A',
                    color: 'good',
                    message: "í´” *BREAKTHROUGH*: Jenkins is now speaking to #all-lois-devops via Channel ID."
                )
            }
        }
    }
}
