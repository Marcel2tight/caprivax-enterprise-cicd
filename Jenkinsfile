pipeline {
    agent any
    
    tools { 
        maven 'Maven3' 
    }

    environment {
        // IDs must match your Jenkins Credentials and Managed Files exactly
        NEXUS_CRED_ID     = 'nexus-auth'
        MAVEN_SETTINGS_ID = 'caprivax-maven-settings'
        SONAR_PROJECT_KEY = 'java-webapp'
        SSH_CRED_ID       = 'target-vm-ssh'
        SLACK_CRED_ID     = 'slack-token'
        
        // Dynamic versioning
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

        /* stage('Deploy to Dev') {
            steps {
                echo "Skipping Dev Deployment - Infra setup in progress"
            }
        }
        */
    }

    post {
        success {
            slackSend(
                botUser: true,
                tokenCredentialId: "${SLACK_CRED_ID}",
                channel: '#all-lois-devops',
                color: 'good',
                message: "✅ *CI SUCCESS*: Build #${env.BUILD_NUMBER} of ${env.JOB_NAME}\nArtifact: smartops-backend-${APP_VERSION}.war\nDetails: ${env.BUILD_URL}"
            )
        }
        failure {
            slackSend(
                botUser: true,
                tokenCredentialId: "${SLACK_CRED_ID}",
                channel: '#all-lois-devops',
                color: 'danger',
                message: "❌ *CI FAILURE*: Build #${env.BUILD_NUMBER} of ${env.JOB_NAME} FAILED.\nCheck logs: ${env.BUILD_URL}console"
            )
        }
        always {
            cleanWs()
        }
    }
}
