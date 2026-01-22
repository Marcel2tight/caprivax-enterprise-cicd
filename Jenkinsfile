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
        // Use a channel name that DEFINITELY exists
        SLACK_CHANNEL     = '#random'  // CHANGE THIS to a working channel
    }

    stages {
        stage('Checkout') {
            steps {
                // Universal checkout - works for both SCM and inline
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/YOUR-USERNAME/YOUR-REPO.git']]
                ])
            }
        }
        
        stage('Simple Test') {
            steps {
                echo "Build started"
                echo "Testing Slack to: ${SLACK_CHANNEL}"
                
                script {
                    // Test Slack first
                    try {
                        slackSend(
                            channel: "${SLACK_CHANNEL}",
                            color: 'good',
                            message: "✅ Jenkinsfile is working! Channel: ${SLACK_CHANNEL}"
                        )
                        echo "Slack test passed"
                    } catch (Exception e) {
                        echo "Slack test failed: ${e.message}"
                    }
                }
            }
        }
    }
}
