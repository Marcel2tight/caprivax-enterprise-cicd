#!/bin/bash
# Caprivax Platform Health Check - Run from Local GitBash

VM_NAME="caprivax-mgmt-plane"
ZONE="us-central1-a"

echo "Ì¥ç Starting Caprivax Platform Health Check..."
echo "------------------------------------------"

# 1. Check Connectivity & Core Tools
echo -n "1. Foundational Tools: "
gcloud compute ssh $VM_NAME --zone=$ZONE --command="java -version 2>&1 | grep 'openjdk version' && mvn -version | head -n 1 && ansible --version | head -n 1" | tr '\n' ' '
echo " ‚úÖ"

# 2. Check Jenkins Service
echo -n "2. Jenkins Service:    "
JENKINS_STATUS=$(gcloud compute ssh $VM_NAME --zone=$ZONE --command="sudo systemctl is-active jenkins")
if [ "$JENKINS_STATUS" == "active" ]; then echo "Running ‚úÖ"; else echo "FAILED ‚ùå"; fi

# 3. Check Docker Containers (SonarQube & Nexus)
echo "3. Docker Containers:"
gcloud compute ssh $VM_NAME --zone=$ZONE --command="sudo docker ps --format '   - {{.Names}}: {{.Status}}'"

# 4. Check Port Accessibility (Local Listeners)
echo "4. Port Listeners:"
gcloud compute ssh $VM_NAME --zone=$ZONE --command="sudo netstat -tulpn | grep -E '8080|8081|9000'" | awk '{print "   - Port " $4 " is active."}'

echo "------------------------------------------"
echo "ÌøÅ Verification Complete."
