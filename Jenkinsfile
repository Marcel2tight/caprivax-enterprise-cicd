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
        // Use a known working channel first
        SLACK_CHANNEL     = '#random'  // Change to a channel that exists
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],  // Changed from master to main
                    extensions: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/YOUR-USERNAME/YOUR-REPO.git',
                        credentialsId: 'your-github-credential'  // Add if private repo
                    ]]
                ])
            }
        }
        
        stage('Test') {
            steps {
                echo "✅ Checkout successful!"
                echo "Testing Slack notification..."
                
                script {
                    try {
                        slackSend(
                            channel: "${SLACK_CHANNEL}",
                            color: 'good',
                            message: "✅ Jenkins pipeline started successfully!\nBranch: main\nBuild: #${env.BUILD_NUMBER}"
                        )
                        echo "✅ Slack notification sent to ${SLACK_CHANNEL}"
                    } catch (Exception e) {
                        echo "⚠️ Slack failed: ${e.message}"
                        echo "Trying alternative channel..."
                        
                        // Fallback to general channel
                        try {
                            slackSend(
                                channel: '#general',
                                color: 'warning',
                                message: "⚠️ Jenkins build #${env.BUILD_NUMBER} started (main channel failed)"
                            )
                        } catch (Exception e2) {
                            echo "❌ Both Slack channels failed"
                        }
                    }
                }
            }
        }
    }
}
