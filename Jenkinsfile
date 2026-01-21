pipeline {
    agent any

    environment {
        APP_VERSION = "1.0.${BUILD_NUMBER}"
        SCANNER_HOME = tool 'SonarScanner'
        NEXUS_IP = '10.128.0.7' 
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Marcel2tight/caprivax-enterprise-cicd.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "mvn -f smartops-backend/pom.xml clean verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=java-webapp -Drevision=${APP_VERSION}"
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build & Deploy to Nexus') {
            steps {
                withCredentials([string(credentialsId: 'nexus-pwd-id', variable: 'NEXUS_PWD')]) {
                    configFileProvider([configFile(fileId: 'caprivax-maven-settings', variable: 'MAVEN_SETTINGS')]) {
                        sh "mvn -s $MAVEN_SETTINGS -f smartops-backend/pom.xml deploy -DskipTests -Drevision=${APP_VERSION}"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            slackSend(
                botUser: true,
                color: 'good',
                channel: '#build-status',
                message: "✅ *SUCCESS*: Job '${env.JOB_NAME}' [${env.BUILD_NUMBER}]\nView build: ${env.BUILD_URL}"
            )
        }
        failure {
            slackSend(
                botUser: true,
                color: 'danger',
                channel: '#build-status',
                message: "❌ *FAILURE*: Job '${env.JOB_NAME}' [${env.BUILD_NUMBER}]\nCheck logs: ${env.BUILD_URL}console"
            )
        }
    }
}
