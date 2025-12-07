Completed Steps: CI/CD Pipeline Setup for Brain-Tasks-App
1. Cloned Repository
Cloned the Brain-Tasks-App repository from GitHub to local/EC2

Navigated into the project directory

2. Docker Setup & Configuration
Created Dockerfile using Node 18 Alpine base image

Configured to copy dist/ directory and serve static content

Created .dockerignore to exclude unnecessary files

Built Docker image: brain-tasks-app:latest

Successfully ran container and tested at http://<EC2-public-ip>:3000

3. Pushed Image to AWS ECR
Created private ECR repository: brain-tasks-app

Authenticated Docker to ECR using AWS CLI

Tagged and pushed Docker image to ECR repository

4. Created AWS EKS Cluster
Set up EKS cluster named brain-tasks-eks using eksctl

Configured cluster with 2 t3.small worker nodes in ap-south-1 region

Configured kubectl to access the EKS cluster

Verified cluster status with kubectl get nodes

5. Kubernetes Deployment & Service
Created k8s/ directory for Kubernetes manifests

Created deployment.yaml with 2 replicas using ECR image

Created service.yaml with LoadBalancer type (port 80 → 3000)

Applied Kubernetes manifests successfully

Verified LoadBalancer endpoint accessibility

6. AWS CodeBuild – CI Implementation
Created buildspec.yml with complete CI pipeline:

Pre-build: ECR login and image tagging

Build: Docker image creation

Post-build: Push to ECR and deployment file updates

Artifacts: Prepared for CodeDeploy (appspec.yml, k8s manifests, scripts)

Created CodeBuild project with:

GitHub source integration

Amazon Linux 2 environment with privileged mode

Configured AWS_ACCOUNT_ID environment variable

S3 artifact output configuration

7. AWS CodeDeploy – CD Implementation
Created appspec.yml for deployment specifications

Created deploy.sh script for Kubernetes deployment:

Updates kubeconfig

Applies Kubernetes manifests

Verifies deployment status

Set up CodeDeploy application for EC2/On-premises

Configured Deployment Group with appropriate IAM roles and permissions

Connected EC2 instances running CodeDeploy agent

Successfully tested deployment using artifacts from CodeBuild

📊 Current Status: Complete end-to-end CI/CD pipeline operational with automated build, container registry push, and Kubernetes deployment via CodeBuild and CodeDeploy.
