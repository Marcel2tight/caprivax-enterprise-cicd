pipeline {
    agent any
    
    tools { 
        maven 'Maven3' 
    }

    environment {
        // Infrastructure Identifiers
        NEXUS_CRED_ID     = 'nexus-auth'
        MAVEN_SETTINGS_ID = 'caprivax-maven-settings'
        SONAR_PROJECT_KEY = 'smartops-backend'
        SSH_CRED_ID       = 'target-vm-ssh'
        MGMT_INTERNAL_IP  = '10.128.0.7'
        
        // Versioning & Notifications
        APP_VERSION       = "1.0.${env.BUILD_ID}"
        SLACK_CHANNEL     = 'C09PEC2E03A'
        SLACK_CRED_ID     = 'slack-token'
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        
        stage('Quality Scan') {
            steps {
                configFileProvider([configFile(fileId: "${MAVEN_SETTINGS_ID}", variable: 'MAVEN_SETTINGS')]) {
                    withCredentials([usernamePassword(credentialsId: "${NEXUS_CRED_ID}", passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                        withSonarQubeEnv('SonarQube') {
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
                            -e 'app_version=${APP_VERSION}' -e \"nexus_pwd=${NEXUS_PWD}\""
                    }
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                sshagent([SSH_CRED_ID]) {
                    withCredentials([usernamePassword(credentialsId: "${NEXUS_CRED_ID}", passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                        sh "ansible-playbook -i ansible/inventory/staging.ini ansible/deploy.yml \
                            -e 'app_version=${APP_VERSION}' -e \"nexus_pwd=${NEXUS_PWD}\""
                    }
                }
            }
        }

        stage('Promote to Production') {
            steps {
                input message: "Approve deployment to PRODUCTION Cluster?", ok: "Deploy Now"
                sshagent([SSH_CRED_ID]) {
                    withCredentials([usernamePassword(credentialsId: "${NEXUS_CRED_ID}", passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USR')]) {
                        sh "ansible-playbook -i ansible/inventory/prod.ini ansible/deploy.yml \
                            -e 'app_version=${APP_VERSION}' -e \"nexus_pwd=${NEXUS_PWD}\""
                    }
                }
            }
        }
    }

    post {
        always {
            slackSend channel: "${env.SLACK_CHANNEL}",
                      color: (currentBuild.currentResult == 'SUCCESS') ? 'good' : 'danger',
                      message: "Build #${env.BUILD_NUMBER} - ${env.JOB_NAME}\nStatus: ${currentBuild.currentResult}\nDetails: ${env.BUILD_URL}"
        }
    }
}
