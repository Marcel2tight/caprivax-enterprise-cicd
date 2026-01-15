#!/bin/bash
# Install Foundation
sudo apt update && sudo apt install -y openjdk-17-jdk maven docker.io ansible curl git

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update && sudo apt install -y jenkins
sudo usermod -aG docker jenkins && sudo systemctl restart jenkins

# Persistence Setup
sudo mkdir -p /opt/sonarqube_data /opt/sonarqube_extensions /opt/sonarqube_logs /opt/nexus_data
sudo chmod -R 777 /opt/sonarqube_data /opt/sonarqube_extensions /opt/sonarqube_logs /opt/nexus_data

# Run SonarQube (Persistent)
sudo docker run -d --name sonarqube -p 9000:9000 \
  -v /opt/sonarqube_data:/opt/sonarqube/data \
  -v /opt/sonarqube_extensions:/opt/sonarqube/extensions \
  -v /opt/sonarqube_logs:/opt/sonarqube/logs \
  sonarqube:lts-community

# Run Nexus (Persistent)
sudo docker run -d --name nexus -p 8081:8081 \
  -v /opt/nexus_data:/nexus-data \
  sonatype/nexus3
