# Caprivax CI/CD Platform 🚀
**Enterprise-Grade Infrastructure-as-Code & Automated Observability on GCP**

## 📌 Project Overview
This repository contains the complete architecture for a multi-environment CI/CD platform deployed on Google Cloud Platform. It utilizes a "Modular Monorepo" pattern to manage Infrastructure-as-Code (IaC), automated server hydration, and a full observability stack.

**Key Highlights:**
- **Separation of Planes**: Logic divided into a "Management Plane" (Control Center) and "Data Plane" (Dev/Staging/Prod).
- **Binary-to-Metric Pipeline**: Automated flow from Java source code to Prometheus-scraped JVM metrics.
- **Artifact Integrity**: Immutable versioning using Nexus Repository Manager for reliable rollbacks.
- **Full-Stack Monitoring**: Real-time health visualization via Grafana, monitoring JVM heap, CPU, and Uptime.

## 🏗️ Repository Structure
caprivax-cicd-platform/
├── bootstrap/ # Standalone Management Plane (Hydration scripts)
├── smartops-backend/ # Spring Boot API with Actuator & Micrometer
├── ansible/ # Configuration Management (Deployment & Systemd)
├── jenkins-infrastructure/ # The Data Plane (Terraform Modules)
│ ├── modules/ # Reusable blocks (Networking, Monitoring, IAM)
│ └── environments/ # Environment-specific configs (Dev, Staging, Prod)
├── terraform-pipelines/ # Groovy Pipelines-as-Code for Jenkins orchestration
└── README.md # Project Documentation

text

## 📊 Technical Architecture

```mermaid
graph TD
    subgraph "Management Plane (GCP VM)"
        J[Jenkins Controller]
        N[Nexus Repository]
        P[Prometheus]
        G[Grafana]
    end

    subgraph "Data Plane (GCP VPC)"
        D[Dev Instance: 10.128.0.8]
        S[Staging Instance: 10.128.0.10]
        P1[Prod Instance 1: 10.128.0.9]
        P2[Prod Instance 2: 10.128.0.12]
    end

    GitHub[GitHub Repo] -->|Webhook| J
    J -->|Maven Build| N
    J -->|Ansible Deploy| D
    J -->|Ansible Deploy| S
    J -->|Ansible Deploy| P1
    J -->|Ansible Deploy| P2
    D -->|Metrics /actuator| P
    S -->|Metrics /actuator| P
    P1 -->|Metrics /actuator| P
    P2 -->|Metrics /actuator| P
    P -->|Data Source| G
    User((Engineer)) -->|IAP Tunnel| J
🛠️ Tech Stack & Tools
Infrastructure: Terraform (Modular HCL)

CI/CD: Jenkins (Multistage Groovy Pipelines)

Build Tool: Maven (Customized with Spring Boot Repackaging)

Config Management: Ansible

Cloud: Google Cloud Platform (VPC, Compute Engine, IAM)

Monitoring: Prometheus, Grafana, Micrometer

Artifacts: Sonatype Nexus

Code Quality: SonarQube

🚀 Deployment Logic
1. The Management Plane (The Director)
The platform is anchored by a hydrated Manager VM. This acts as the Jenkins Controller, Nexus Repository, and Monitoring Hub. It orchestrates the lifecycle of the entire fleet.

2. Automated Application Lifecycle
Build: Jenkins compiles the SmartOps API into an executable "Fat JAR"

Quality: SonarQube scans for vulnerabilities and code smells

Store: Versioned artifacts stored in Nexus Repository

Deploy: Ansible fetches the versioned JAR and deploys to target VMs with systemd for high availability

3. Observability Stack
Deployed as a Docker-composed stack, featuring:

Prometheus: Scrapes /actuator/prometheus endpoints across the fleet

Grafana: Visualizes health via Dashboard 11378 (JVM Micrometer Statistics)

Fleet Management: Multi-target scraping with environment-based labels (dev, staging, prod)

🔒 Security Posture
Least Privilege: CI/CD actions performed via dedicated Service Accounts

Network Isolation: Internal communication restricted to authorized ports (8080 for API, 9090 for Scraping)

Stability: Optimized Management Plane with 2GB Swap configuration for build reliability

🎯 Technical Challenges & Solutions
Challenge	Solution
Configuration Drift	Resolved systemd failures by using Ansible to enforce state, ensuring the transition from .war to .jar was synchronized across the fleet
Resource Exhaustion	Mitigated Jenkins build failures on the Management Plane by implementing a 2GB Linux swapfile and optimizing JVM heap settings
Observability Gaps	Instrumented Spring Boot with Micrometer and Prometheus Actuator to move beyond basic "up/down" checks to deep JVM telemetry
Artifact Portability	Integrated the spring-boot-maven-plugin to repackage standard JARs into executable "Fat JARs," ensuring all dependencies were bundled for cloud deployment
👤 Author
Marcel Owhonda - Cloud & DevOps Engineer

GitHub: @Marcel2tight

LinkedIn: Marcel Owhonda

This project demonstrates advanced expertise in GCP Cloud Engineering, Java Application Lifecycle Management, and Enterprise Monitoring.