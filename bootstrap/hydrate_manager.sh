#!/bin/bash
sudo apt update && sudo apt install -y openjdk-17-jdk maven docker.io ansible curl git

# Persistence Setup
sudo mkdir -p /opt/sonarqube_data /opt/nexus_data /opt/prometheus_data /opt/grafana_data /opt/alertmanager_data
sudo chmod -R 777 /opt/sonarqube_data /opt/nexus_data /opt/prometheus_data /opt/grafana_data /opt/alertmanager_data

# Run Infrastructure
sudo docker run -d --name sonarqube -p 9000:9000 -v /opt/sonarqube_data:/opt/sonarqube/data sonarqube:lts-community
sudo docker run -d --name nexus -p 8081:8081 -v /opt/nexus_data:/nexus-data sonatype/nexus3
sudo docker run -d --name prometheus -p 9090:9090 -v /opt/prometheus_data:/prometheus prom/prometheus:latest
sudo docker run -d --name grafana -p 3000:3000 -v /opt/grafana_data:/var/lib/grafana grafana/grafana:latest

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update && sudo apt install -y jenkins
sudo usermod -aG docker jenkins && sudo systemctl restart jenkins
