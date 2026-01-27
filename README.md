# Caprivax CI/CD Platform 🚀
### Enterprise-Grade Infrastructure-as-Code & Automated Observability on GCP

![GCP](https://img.shields.io/badge/GCP-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white) ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) ![Jenkins](https://img.shields.io/badge/jenkins-%23D24939.svg?style=for-the-badge&logo=jenkins&logoColor=white) ![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white) ![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white) ![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white) ![Slack](https://img.shields.io/badge/Slack-4A154B?style=for-the-badge&logo=slack&logoColor=white)

---

## 📌 Project Overview
This repository contains the complete architecture for a multi-environment CI/CD platform deployed on Google Cloud Platform. It utilizes a **Modular Monorepo** pattern to manage Infrastructure-as-Code (IaC), automated server hydration, and a full observability stack.

### 🌟 Key Highlights
* **Separation of Planes:** Logic divided into a "Management Plane" (Control Center) and "Data Plane" (Dev/Staging/Prod).
* **Binary-to-Metric Pipeline:** Automated flow from Java source code to Prometheus-scraped JVM metrics.
* **Artifact Integrity:** Immutable versioning using Nexus Repository Manager.
* **Full-Stack Monitoring:** Real-time visualization via Grafana (Heap, CPU, and Uptime).

---

## 🏗️ Repository Structure
```text
caprivax-cicd-platform/
├── bootstrap/                # Standalone Management Plane (Hydration scripts)
├── smartops-backend/         # Spring Boot API with Actuator & Micrometer
├── ansible/                  # Configuration Management (Deployment & Systemd)
├── jenkins-infrastructure/   # The Data Plane (Terraform Modules)
├── terraform-pipelines/      # Groovy Pipelines-as-Code for Jenkins
└── README.md                 # Project Documentation
🚀 Deployment Logic & Visual Evidence1. Automated Application LifecycleSuccessfully orchestrated a 5-stage pipeline including automated testing, quality gates, and a manual promotion step for Production deployment.<p align="center"><img src="docs/pipeline.png" width="900" alt="Jenkins Pipeline Success" /><i>Visual proof of the multi-stage CI/CD pipeline execution.</i></p>2. Full-Stack Observability & AlertingThe platform features proactive monitoring. JVM telemetry is instrumented via Micrometer, scraped by Prometheus, and visualized in Grafana with integrated Slack webhooks.<p align="center"><img src="docs/prometheus-targets.png" width="900" alt="Prometheus Health" /><i>Prometheus dashboard showing 4/4 active 'smartops-enterprise-fleet' targets.</i></p><p align="center"><img src="docs/grafana.png" width="48%" alt="Grafana Dashboard" /><img src="docs/slack.png" width="48%" alt="Slack Alerts" /><i>Live JVM Telemetry Dashboard (Left) and Automated Slack Notifications (Right).</i></p>🧠 Technical Challenges & SolutionsChallengeSolutionConfiguration DriftUsed Ansible to enforce state across the fleet, managing systemd service transitions.Resource ExhaustionMitigated Jenkins build failures by implementing a 2.00 GiB swap file on the Management Plane.Artifact PortabilityIntegrated spring-boot-maven-plugin to repackage standard JARs into executable "Fat JARs."👤 AuthorMarcel Owhonda - Cloud & DevOps EngineerGitHub: @Marcel2tightLinkedIn: Marcel OwhondaThis project demonstrates advanced expertise in GCP Cloud Engineering, Java Application Lifecycle Management, and Enterprise Monitoring.