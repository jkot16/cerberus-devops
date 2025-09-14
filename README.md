# Cerberus-DevOps

[![CI/CD Status](https://img.shields.io/github/actions/workflow/status/jkot16/cerberus-devops/main.yml?branch=main)](https://github.com/jkot16/cerberus-devops/actions) [![Docker Pulls](https://img.shields.io/docker/pulls/jkot16/cerberus-app)](https://hub.docker.com/r/jkot16/cerberus-app) [![Trivy Scan](https://img.shields.io/badge/security--scan-passing-brightgreen.svg)](https://github.com/jkot16/cerberus-devops/actions)


![Cerberus Status Dashboard](https://github.com/user-attachments/assets/6970d268-7e7f-4467-9e2f-c0e0139dbec2)


---

## Table of Contents

1. [🔎 Project Overview](#1-project-overview)  
2. [🛠️ Features](#2-features)  
3. [⚙️ Tech Stack](#3-tech-stack)  
4. [📦 Installation & Usage](#4-installation--usage)  
5. [🧪 Running Tests](#5-running-tests)  
6. [🔄 CI/CD Workflow](#6-cicd-workflow)  
7. [📈 Monitoring & Alerts](#7-monitoring--alerts)  
8. [🛡️ Security](#8-security)  
9. [🗺️ Roadmap](#9-roadmap)


---

## 1. Project Overview

**Cerberus** is a lightweight Flask application containerized with Docker that self-monitors its `/ping` endpoint every minute, logs each result, sends green (OK) or red (FAIL) alerts to Discord, and provides a web dashboard showing the last ten checks. It also includes a GitHub Actions pipeline to run tests, perform Trivy security scans, build and push the Docker image, and deploy automatically to AWS EC2.

---
## 2. Features



- **Endpoints**:  
  - `/` – “Hello from Cerberus”  
  - `/ping` – health check returns `{ "status": "ok" }`  
  - `/status` – dashboard of last 10 log entries  
- **Logging**: timestamped status messages in `/app/cerberus.log`  
- **Cron job**: runs `cerberus-healthcheck.sh` every minute
- **Discord alerts**: rich embeds via Webhook for OK and ERROR states  
- **Dashboard**: styled HTML/CSS with neon-glow animations and log rotation  

---

## 3. Tech Stack

- **Backend:** Python 3.11, Flask  
- **Container:** Docker 
- **Scripting:** Bash
- **Scheduling:** Cron job for periodic health checks 
- **CI/CD:** GitHub Actions (pytest, Trivy, build & push, EC2 deploy)  
- **Hosting:** AWS EC2, Docker Hub  
- **Notifications:** Discord Webhooks  

---

## 4. Installation & Usage

```bash
git clone https://github.com/jkot16/cerberus-devops.git
cd cerberus-devops

# 1. Build the Docker image
docker build -t cerberus-app .

# 2. Run the container (replace with your Discord webhook URL)
docker run -d \
  --name cerberus \
  -p 5000:5000 \
  -e CERBERUS_WEBHOOK_URL="YOUR_DISCORD_WEBHOOK" \
  cerberus-app
```

---

## 5. Running Tests
Run the test suite locally before pushing:
```python
pytest test_app.py
```

---

## 6. CI/CD Workflow
Defined in .github/workflows/main.yml, the pipeline runs on every push to main:
- Checkout & setup Python 3.11 + cache pip
- Run pytest
- Scan Docker image with Trivy (fails on HIGH/CRITICAL)
- Build & push Docker image to Docker Hub
- Deploy to AWS EC2 via SSH (pull new image, stop old container, start new)

---

## 7. Monitoring & Alerts

Cron runs **cerberus-healthcheck.sh** every minute.
The full health-check script lives in [`scripts/cerberus-healthcheck.sh`](./cerberus-healthcheck.sh),
here’s the core logic:

```bash
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/ping)
if [ "$RESPONSE" == "200" ]; then
  STATUS="Cerberus is guarding the gates – all clear 🟢"
else
  STATUS="Cerberus is missing from his post! ❌ Status: $RESPONSE"
fi
curl -s -H "Content-Type: application/json" \
     -X POST --data "$JSON" \
     "$CERBERUS_WEBHOOK_URL"
```
![dc](https://github.com/user-attachments/assets/26f102c2-0610-40f1-9bc6-a0f739656580)


---

## 8. Security
- Secrets managed via environment variables & GitHub Secrets
- Automated Trivy scans on every push to catch vulnerabilities
- Fail-fast CI: pipeline stops if tests or security checks fail
- Build context optimized using `.dockerignore` to exclude sensitive or unnecessary files

---

## 9. Roadmap
For more upcoming features and tracked improvements, see:  
👉 [GitHub Issues for Cerberus](https://github.com/jkot16/cerberus-devops/issues)

---
