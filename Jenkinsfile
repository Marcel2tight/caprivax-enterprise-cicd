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
        // Use a channel that definitely exists - start with #random
        SLACK_CHANNEL     = '#random'
    }

    stages {
        stage('Checkout') {
            steps {
                // SIMPLE checkout - let Jenkins handle it
                checkout scm
            }
        }
        
        stage('Test Build') {
            steps {
                echo "✅ Checkout successful!"
                echo "Build ID: ${env.BUILD_ID}"
                echo "Testing Slack to: ${SLACK_CHANNEL}"
                
                script {
                    // Simple Slack test
                    try {
                        slackSend(
                            channel: "${SLACK_CHANNEL}",
                            color: 'good',
                            message: "✅ Jenkins pipeline started!\nBuild: #${env.BUILD_NUMBER}\nRepo: caprivax-enterprise-cicd"
                        )
                        echo "✅ Slack sent to ${SLACK_CHANNEL}"
                    } catch (Exception e) {
                        echo "⚠️ Slack test failed: ${e.message}"
                        echo "We'll continue without Slack for now"
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo "Build ${currentBuild.currentResult} - ${env.BUILD_URL}"
        }
    }
}
