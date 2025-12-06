#!/bin/bash
set -e

APP_DIR="/opt/brain-tasks-app"
AWS_REGION="ap-south-1"
CLUSTER_NAME="brain-tasks-eks"

echo "Starting deployment to EKS..."

cd "$APP_DIR"

# Update kubeconfig (uses IAM role of this instance)
aws eks update-kubeconfig --region "$AWS_REGION" --name "$CLUSTER_NAME"

# Apply manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "Deployment applied. Current pods:"
kubectl get pods -o wide

echo "Deployment to EKS completed."

