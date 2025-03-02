#!/bin/bash
# Minikube setup and troubleshooting script

echo "=== Checking Minikube Status ==="
minikube status

# If Minikube is not running, start it
if [ $? -ne 0 ]; then
  echo "=== Starting Minikube ==="
  minikube start
fi

echo "=== Verifying kubectl configuration ==="
kubectl config current-context

echo "=== Setting kubectl context to Minikube ==="
kubectl config use-context minikube

echo "=== Verifying connection to Minikube ==="
kubectl get nodes

echo "=== Applying Kubernetes deployment ==="
kubectl apply -f calculator-deployment.yaml

echo "=== Checking deployment status ==="
kubectl get pods
kubectl get deployments

echo "=== Checking service status ==="
kubectl get services calculator-service

echo "=== Getting URL to access the application ==="
minikube service calculator-service --url
