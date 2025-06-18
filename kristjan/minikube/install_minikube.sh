#!/bin/bash

set -e

echo "🐳 Setting up Minikube with Docker on Linux..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Minikube if not present
if ! command_exists minikube; then
    echo "📦 Installing Minikube..."
    curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
fi

 Install kubectl if not present
if ! command_exists kubectl; then
    echo "📦 Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
fi

# Start Minikube with Docker driver
#echo "🚀 Starting Minikube with Docker driver..."
#minikube start --driver=docker --cpus=2 --memory=4g

# Set Docker as default driver
#minikube config set driver docker

# Enable useful addons
#echo "📦 Enabling useful addons..."
#minikube addons enable dashboard
#minikube addons enable metrics-server
#minikube addons enable ingress

# Verify installation
#echo "✅ Verifying installation..."
#minikube status
#kubectl get nodes
#
#echo "🎉 Minikube setup complete!"
#echo ""
#echo "Useful commands:"
#echo "  minikube dashboard    # Open Kubernetes dashboard"
#echo "  minikube service list # List all services"
#echo "  minikube stop         # Stop the cluster"
#echo "  minikube delete       # Delete the cluster"

echo "🎉 Setup complete!"