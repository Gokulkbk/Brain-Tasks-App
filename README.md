1. Clone Repository (Local/EC2)

Cloned repo:

git clone https://github.com/Vennilavan12/Brain-Tasks-App.git
cd Brain-Tasks-App

2️. Docker Setup
Create Dockerfile

Use Node 18 Alpine.

Copy dist/ directory.

Install serve static server.

Expose port 3000.

Run app using:

CMD ["serve", "-s", "dist", "-l", "3000"]

Create .dockerignore

Ignore git folders, node_modules, IDE configs.

Build & Run Docker Image

Build:

docker build -t brain-tasks-app:latest .


Run:

docker run -d --name brain-tasks -p 3000:3000 brain-tasks-app:latest


Test in browser:

http://<EC2-public-ip>:3000

3️. Push Image to AWS ECR
Create ECR Repository

AWS Console → ECR → Create repository

Name: brain-tasks-app

Visibility: Private

Authenticate Docker to ECR
aws ecr get-login-password --region ap-south-1 | \
docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com

Tag & Push Image
docker tag brain-tasks-app:latest <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest
docker push <ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:latest

4️. Create AWS EKS Cluster Using eksctl
Create Cluster
eksctl create cluster \
  --name brain-tasks-eks \
  --region ap-south-1 \
  --nodegroup-name standard-workers \
  --node-type t3.small \
  --nodes 2 \
  --managed

Configure kubectl
aws eks update-kubeconfig --region ap-south-1 --name brain-tasks-eks
kubectl get nodes

5️. Kubernetes Deployment & Service
Create k8s Folder
mkdir k8s

Deployment YAML

Deploy 2 replicas

Use ECR image

Expose containerPort 3000

Service YAML

Type: LoadBalancer

Expose port 80 → targetPort 3000

Apply Manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

Check LoadBalancer IP
kubectl get svc brain-tasks-service

6️. AWS CodeBuild – CI Step
Purpose

Build Docker image inside CodeBuild

Push to ECR

Update Kubernetes deployment with new image tag

Export artifacts to S3 (for CodeDeploy)

Create buildspec.yml

Pre-build:

Login to ECR

Define image tag

Build:

Docker build

Post-build:

Docker push

Replace image path in deployment.yaml

Artifacts:

appspec.yml

k8s/*.yaml

scripts/*.sh

Create CodeBuild Project

Source: GitHub

Environment: Amazon Linux 2, Privileged mode ON

Add environment variable:

AWS_ACCOUNT_ID=<your-id>

Output artifacts to S3 bucket

7. AWS CodeDeploy – CD Step
Create appspec.yml

Files copied to /opt/brain-tasks-app

AfterInstall hook runs deploy.sh

Create deploy.sh

Update kubeconfig

Apply K8s manifests:

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml


Print pod list

Setup CodeDeploy

Create Application → EC2/On-premises

Create Deployment Group:

Attach IAM role with:

EKS permissions

S3

CodeDeploy

Select EC2 instance(s) running CodeDeploy agent

Run Deployment

Use S3 artifact from CodeBuild
