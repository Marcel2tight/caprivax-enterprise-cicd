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
        // Use channel ID - most reliable
        SLACK_CHANNEL_ID  = 'C09PEC2E03A'  // #all-lois-devops
    }

    stages {
        stage('Validate Setup') {
            steps {
                script {
                    echo "Validating environment..."
                    echo "Slack channel ID: ${SLACK_CHANNEL_ID}"
                    echo "App version: ${APP_VERSION}"
                    
                    // Test Slack connectivity
                    try {
                        slackSend(
                            channel: "${SLACK_CHANNEL_ID}",
                            color: 'good',
                            message: "��� Pipeline started: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
                        )
                        echo "✅ Slack is working!"
                    } catch (Exception e) {
                        echo "⚠️ Slack test failed (but continuing): ${e.message}"
                    }
                }
            }
        }
        
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Quality Scan') {
            steps {
                configFileProvider([configFile(fileId: "${MAVEN_SETTINGS_ID}", variable: 'MAVEN_SETTINGS')]) {
                    withCredentials([usernamePassword(credentialsId: "${NEXUS_CRED_ID}", passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                        withSonarQubeEnv('SonarQube') {
                            sh "mvn -s $MAVEN_SETTINGS -f smartops-backend/pom.xml clean verify \
                                org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
                                -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                                -Drevision=${APP_VERSION}"
                        }
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 15, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build & Deploy to Nexus') {
            steps {
                configFileProvider([configFile(fileId: "${MAVEN_SETTINGS_ID}", variable: 'MAVEN_SETTINGS')]) {
                    withCredentials([usernamePassword(credentialsId: "${NEXUS_CRED_ID}", passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                        sh "mvn -s $MAVEN_SETTINGS -f smartops-backend/pom.xml deploy -DskipTests -Drevision=${APP_VERSION}"
                    }
                }
            }
        }
    }

    post {
        success {
            slackSend(
                channel: "${SLACK_CHANNEL_ID}",
                color: 'good',
                message: "✅ SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}\\nVersion: ${APP_VERSION}"
            )
        }
        failure {
            slackSend(
                channel: "${SLACK_CHANNEL_ID}",
                color: 'danger',
                message: "❌ FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}\\nCheck: ${env.BUILD_URL}"
            )
        }
        unstable {
            slackSend(
                channel: "${SLACK_CHANNEL_ID}",
                color: 'warning',
                message: "⚠️ UNSTABLE: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
            )
        }
    }
}
