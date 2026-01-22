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
        SLACK_CHANNEL_ID  = 'C09PEC2E03A'  # Your channel ID
    }

    stages {
        stage('Validate Setup') {
            steps {
                script {
                    echo "Validating SSH credentials: ${SSH_CRED_ID}"
                    try {
                        withCredentials([sshUserPrivateKey(
                            credentialsId: "${SSH_CRED_ID}",
                            keyFileVariable: 'SSH_KEY',
                            usernameVariable: 'SSH_USER'
                        )]) {
                            sh '''
                                echo "✅ SSH credentials validated"
                            '''
                        }
                    } catch (Exception e) {
                        error "❌ SSH credentials '${SSH_CRED_ID}' not found. Please add them in Jenkins Credentials."
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

        stage('Deploy to Dev') {
            steps {
                sshagent(["${SSH_CRED_ID}"]) {
                    withCredentials([usernamePassword(credentialsId: "${NEXUS_CRED_ID}", passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                        sh "ansible-playbook -i ansible/inventory/dev.ini ansible/deploy.yml \
                            -e 'app_version=${APP_VERSION} nexus_pwd=${NEXUS_PWD}'"
                    }
                }
            }
        }

        stage('Promote to Production') {
            steps {
                input message: "Approve deployment to PRODUCTION?", ok: "Deploy Now"
                
                sshagent(["${SSH_CRED_ID}"]) {
                    withCredentials([usernamePassword(credentialsId: "${NEXUS_CRED_ID}", passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                        sh "ansible-playbook -i ansible/inventory/prod.ini ansible/deploy.yml \
                            -e 'app_version=${APP_VERSION} nexus_pwd=${NEXUS_PWD}'"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                def slackMessage = "Build #${env.BUILD_NUMBER} - ${env.JOB_NAME} - Status: ${currentBuild.currentResult}"
                def slackColor = (currentBuild.currentResult == 'SUCCESS') ? 'good' : 'danger'
                
                try {
                    // Using channel ID
                    slackSend(
                        channel: "${SLACK_CHANNEL_ID}",
                        color: slackColor,
                        message: slackMessage
                    )
                } catch (Exception e) {
                    echo "⚠️ Slack notification failed. Error: ${e.message}"
                }
            }
        }
    }
}
