#!/bin/bash

# Add Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

# Update Helm repositories
helm repo update

#Create namespace monitoring 
kubectl create namespace monitoring
# Install Prometheus
helm install prometheus prometheus-community/prometheus \
  --version 14.4.0 \
  --namespace monitoring \
  --set server.service.type=LoadBalancer


helm install grafana grafana/grafana \
  --namespace monitoring \
  --set adminUser=admin \
  --set adminPassword=admin \
  --set service.type=LoadBalancer

