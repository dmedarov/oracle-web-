---
description: Automated Docker Deployment Guide
---

# Automated Docker Deployment Guide

### Step 1: Obtain a Free Oracle Cloud Server (Always Free Tier)

Oracle Cloud offers an Always Free Tier with two virtual machines, providing enough resources for small-scale applications. Go to the Oracle Cloud Free Tier page. Click on Start for Free and fill in the required details to register. Verify your email and provide a valid credit card (no charges unless you opt into paid services). Log in to the Oracle Cloud dashboard after completing verification. After registering, follow these steps to create a free VM:

* Go to the Compute section.
* Click Create Instance and choose an Always Free Eligible image such as Rocky Linux or Ubuntu.
* Select the VM.Standard.E2.1.Micro shape for a free instance.
* Launch the instance and note its public IP for SSH access.

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

### Step 2: Set Up SSH on Oracle VM

To access your Oracle VM securely, you’ll need to set up SSH keys. Follow these steps:

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

Copy your public SSH key to Oracle Cloud’s VM settings, and access your server using the following command:

```
ssh opc@<your_vm_ip>
```

### Step 3: Install Docker on Oracle VM

Next, install Docker on your Oracle Cloud VM or any other Linux server (e.g., Rocky Linux):

```
sudo dnf update
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
```

### Step 4: Install Watchtower

To keep your Docker containers updated automatically, install Watchtower:

```
docker run -d --name watchtower --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower
```

### Step 5: Automate Deployment Using GitHub Actions

Integrate GitHub Actions with Docker Hub and deploy automatically via SSH. Here’s the GitHub Actions workflow for automatic Docker deployment:

```
name: CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      - name: Build Docker image
        run: docker build -t ${{ secrets.DOCKER_HUB_USERNAME }}/my-app:latest .
      - name: Push to Docker Hub
        run: docker push ${{ secrets.DOCKER_HUB_USERNAME }}/my-app:latest

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: SSH to Server
        uses: appleboy/ssh-action@v0.1.10
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            docker pull ${{ secrets.DOCKER_HUB_USERNAME }}/my-app:latest
            docker stop my-app || true
            docker rm my-app || true
            docker run -d --name my-app -p 80:8080 ${{ secrets.DOCKER_HUB_USERNAME }}/my-app:latest
```

© 2023 Automated Docker Deployment Guide. All rights reserved.
