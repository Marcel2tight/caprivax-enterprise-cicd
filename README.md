# Caprivax CI/CD Platform 🚀
### Enterprise-Grade Infrastructure-as-Code & Automated Observability on GCP

![GCP](https://img.shields.io/badge/GCP-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white) ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) ![Jenkins](https://img.shields.io/badge/jenkins-%23D24939.svg?style=for-the-badge&logo=jenkins&logoColor=white) ![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white) ![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white) ![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white) ![Slack](https://img.shields.io/badge/Slack-4A154B?style=for-the-badge&logo=slack&logoColor=white)

📌 **Project Overview**
This repository contains the complete architecture for a multi-environment CI/CD platform deployed on Google Cloud Platform. It utilizes a **Modular Monorepo** pattern to manage Infrastructure-as-Code (IaC), automated server hydration, and a full observability stack.

### 🌟 Key Highlights
* **Separation of Planes:** Logic divided into a "Management Plane" (Control Center) and "Data Plane" (Dev/Staging/Prod).
* **Binary-to-Metric Pipeline:** Automated flow from Java source code to Prometheus-scraped JVM metrics.
* **Artifact Integrity:** Immutable versioning using Nexus Repository Manager for reliable rollbacks.
* **Full-Stack Monitoring:** Real-time health visualization via Grafana, monitoring JVM heap, CPU, and Uptime.

---

### 🏗️ Repository Structure
```text
caprivax-cicd-platform/
├── bootstrap/                # Standalone Management Plane (Hydration scripts)
├── smartops-backend/         # Spring Boot API with Actuator & Micrometer
├── ansible/                  # Configuration Management (Deployment & Systemd)
├── jenkins-infrastructure/   # The Data Plane (Terraform Modules)
│   ├── modules/              # Reusable blocks (Networking, Monitoring, IAM)
│   └── environments/         # Environment-specific configs (Dev, Staging, Prod)
├── terraform-pipelines/      # Groovy Pipelines-as-Code for Jenkins orchestration
└── README.md                 # Project Documentation