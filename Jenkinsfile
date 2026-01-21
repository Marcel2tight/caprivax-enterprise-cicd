pipeline {
    agent any
    
    tools { 
        maven 'Maven3' 
    }

    environment {
        NEXUS_CRED_ID     = 'nexus-auth'
        MAVEN_SETTINGS_ID = 'caprivax-maven-settings'
        SONAR_PROJECT_KEY = 'java-webapp'
        SLACK_CRED_ID     = 'slack-token'
        // Using your verified Channel ID for reliability
        SLACK_CHANNEL     = 'C09PEC2E03A'
        APP_VERSION       = "1.0.${env.BUILD_ID}"
    }

    stages {
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
                botUser: true,
                tokenCredentialId: "${SLACK_CRED_ID}",
                channel: "${SLACK_CHANNEL}",
                color: 'good',
                message: "✅ *CI SUCCESS*: Build #${env.BUILD_NUMBER} for ${env.JOB_NAME}\nArtifact: smartops-backend-${APP_VERSION}.war\nDetails: ${env.BUILD_URL}"
            )
        }
        failure {
            slackSend(
                botUser: true,
                tokenCredentialId: "${SLACK_CRED_ID}",
                channel: "${SLACK_CHANNEL}",
                color: 'danger',
                message: "❌ *CI FAILURE*: Build #${env.BUILD_NUMBER} failed. Check logs: ${env.BUILD_URL}"
            )
        }
        always {
            cleanWs()
        }
    }
}
