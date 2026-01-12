#!/bin/bash
sudo apt update && sudo apt install -y openjdk-17-jdk maven docker.io ansible curl git
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update && sudo apt install -y jenkins
sudo usermod -aG docker jenkins && sudo systemctl restart jenkins
sudo docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community
sudo docker run -d --name nexus -p 8081:8081 sonatype/nexus3
