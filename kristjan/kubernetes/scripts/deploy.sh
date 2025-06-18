#!/bin/bash

set -e

echo "🚀 Deploying Web Application to Minikube..."

# Ensure minikube is running
if ! minikube status &> /dev/null; then
    echo "❌ Minikube is not running. Please start it first:"
    echo "   minikube start"
    exit 1
fi

# Deploy MySQL first (database needs to be ready)
echo "📦 Deploying MySQL database..."
kubectl apply -f ../manifests/mysql.yaml

# Wait for MySQL to be ready
echo "⏳ Waiting for MySQL to be ready..."
kubectl wait --for=condition=available --timeout=120s deployment/mysql

# Deploy web application
echo "📦 Deploying web application..."
kubectl apply -f ../manifests/webapp.yaml

# Wait for webapp to be ready
echo "⏳ Waiting for web application to be ready..."
kubectl wait --for=condition=available --timeout=60s deployment/webapp

# Get deployment info
echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 Deployment Status:"
kubectl get pods -l app=webapp -o wide
echo ""
kubectl get services webapp-service
echo ""

# Show access methods
echo "🌐 Access Methods:"
echo ""
echo "   Method 1 (Recommended): Port Forward"
echo "   └── kubectl port-forward service/webapp-service 8080:80"
echo "   └── Then visit: http://127.0.0.1:8080"
echo ""
echo "   Method 2: Minikube Service"
echo "   └── minikube service webapp-service"
echo ""

# Ask user if they want to start port forwarding
read -p "🚀 Start port forwarding now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "🔗 Starting port forwarding..."
    echo "   Local URL: http://127.0.0.1:8080"
    echo "   Press Ctrl+C to stop port forwarding"
    echo ""
    echo "Starting port forward in 3 seconds..."
    sleep 3
    kubectl port-forward service/webapp-service 8080:80
else
    echo ""
    echo "💡 To access later, run:"
    echo "   kubectl port-forward service/webapp-service 8080:80"
fi

echo ""
echo "🛑 To clean up:"
echo "   kubectl delete -f ../manifests/"