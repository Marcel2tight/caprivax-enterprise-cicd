pipeline {
    agent any
    stages {
        stage('Exact Test') {
            steps {
                script {
                    // Use the slackSend step with minimal params
                    slackSend channel: '#random', 
                              color: 'good', 
                              message: 'Exact test'
                }
            }
        }
    }
}
