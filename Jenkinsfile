pipeline {
    agent any
    
    tools { 
        maven 'Maven3' 
    }

    environment {
        // IDs must match your Jenkins Credentials and Managed Files exactly
        NEXUS_CRED_ID     = 'nexus-auth'
        MAVEN_SETTINGS_ID = 'caprivax-maven-settings'
        SONAR_PROJECT_KEY = 'smartops-backend'
        SSH_CRED_ID       = 'target-vm-ssh'
        // Internal IP of the Management Plane for stable tool communication
        MGMT_INTERNAL_IP  = '10.128.0.7'
        // Dynamic versioning: Uses Jenkins Build ID to ensure unique artifacts
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
                            // Using -Dsonar.host.url as a backup to the Global Configuration
                            sh "mvn -s $MAVEN_SETTINGS -f smartops-backend/pom.xml clean verify \
                                org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
                                -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                                -Dsonar.host.url=http://${MGMT_INTERNAL_IP}:9000 \
                                -Drevision=${APP_VERSION}"
                        }
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                // Ensure SonarQube Webhook is set to http://10.128.0.7:8080/sonarqube-webhook/
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
                sshagent([SSH_CRED_ID]) {
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
                
                sshagent([SSH_CRED_ID]) {
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
            // Use the variable ${SLACK_CHANNEL} which holds the ID 'C09PEC2E03A'
            slackSend channel: "${SLACK_CHANNEL}",
                      color: (currentBuild.currentResult == 'SUCCESS') ? 'good' : 'danger',
                      message: "Build #${env.BUILD_NUMBER} of ${env.JOB_NAME} - Status: ${currentBuild.currentResult} \nDetails: ${env.BUILD_URL}"  
        }
        failure {
            // Again, use the variable instead of the hardcoded name
            slackSend channel: "${SLACK_CHANNEL}",
                      color: 'danger',
                      message: "❌ ALERT: Build #${env.BUILD_NUMBER} FAILED. Review logs at: ${env.BUILD_URL}"
        }
    }
}
