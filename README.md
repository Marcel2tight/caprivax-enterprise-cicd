# Caprivax Enterprise CI/CD Platform Ì∫Ä

### Multi-Stage Infrastructure-as-Code & Automated Observability on GCP

---

## Ì≥å Project Overview
The **Caprivax-Core** platform is an enterprise-grade CI/CD ecosystem designed for high-velocity Spring Boot deployments. It implements a **Modular Monorepo** pattern, separating the management plane (automation server) from the data plane (application workloads).

### Key Features:
* **Automated Hydration:** One-click bootstrap of Jenkins, SonarQube, and Nexus using Docker.
* **Security-Centric:** Least-privilege IAM roles and isolated environment inventories.
* **Observability:** Full-stack monitoring via Prometheus and Spring Boot Actuator.
* **Configuration Management:** Ansible-driven deployments to Dev, Staging, and Production.

---

## ÌøóÔ∏è Repository Architecture

| Component | Directory | Responsibility |
| :--- | :--- | :--- |
| **Management Plane** | \`bootstrap/\` | Jenkins, Nexus, & SonarQube Hydration |
| **Application Plane** | \`smartops-backend/\` | Java Source, Maven POM, & Observability Config |
| **Control Plane** | \`ansible/\` | Deployment Playbooks & Env Inventories |
| **Orchestration** | \`jenkins-pipelines/\` | Multistage Groovy Pipelines-as-Code |

---

## Ìª†Ô∏è Technology Stack
* **Cloud:** Google Cloud Platform (GCP)
* **CI/CD:** Jenkins, GitHub Webhooks
* **Build/QA:** Maven, SonarQube (SAST), CheckStyle
* **Artifactry:** Sonatype Nexus
* **Automation:** Ansible
* **Observability:** Prometheus, Spring Boot Actuator
* **Security:** GCP IAM, IAP Tunneling

---

## Ì±§ Author
**Marcel Owhonda - Cloud & DevOps Engineer**
- **GitHub:** [@Marcel2tight](https://github.com/Marcel2tight)
- **LinkedIn:** [Marcel Owhonda](https://www.linkedin.com/in/marcel-owhonda-devops)

---
*Built as a Capstone project for advanced GCP Cloud Engineering and DevOps Automation.*
