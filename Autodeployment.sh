#!/bin/bash

# Step 1: Install necessary tools
echo "Step 1: Installing necessary tools"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install -y terraform
sudo apt install snapd -y
sudo snap install kubectl --classic
echo "Step 2: Installing Azure CLI"
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
  sudo gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg
AZ_DIST=$(lsb_release -cs)
echo "Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/azure-cli.sources
sudo apt-get update
sudo apt-get install azure-cli

echo "Step 3: Installing Helm (monitoring instalation tool)"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh
echo "Installation of needed tools and will proceed to an update and upgrade"
sudo apt-get update && sudo apt upgrade -y


# Step 4: Azure Login
echo "Step 4: Logging into Azure"
az login --use-device-code

# Step 5: Initialize Terraform
echo "Step 5: Initializing Terraform"
cd ./terraform
terraform init

# Step 6: Apply Terraform Changes
echo "Step 6: Applying Terraform Changes"
# Replace './yourpath' with the actual path to your Terraform configuration files
terraform apply -auto-approve
az aks get-credentials --resource-group phpipam_resources --name phpipam-aks-cluster --overwrite-existing
cd ..

# Step 7: Deploy Kubernetes Services with user input for passwords user and database name
echo "Step 7: Deploying Kubernetes Services"
cd ./kubernetes
# Prompt user for MySQL credentials
read -sp "Enter MySQL root password: " root_password
echo
read -p "Enter MySQL username: " user
read -sp "Enter MySQL user password: " user_password
echo
read -p "Enter MySQL database name: " database_name

# Create secrets for MySQL
echo "Creating secrets for MySQL"
kubectl create secret generic mysql-secret \
  --from-literal=root-password="$root_password" \
  --from-literal=user="$user" \
  --from-literal=password="$user_password" \
  --from-literal=database="$database_name"

kubectl apply -f deploy_Mysql\&phpmyadmin_withpvc.yaml
kubectl apply -f deployment_phpipam.yaml
cd ..

# Step 8: Deploy Prometheus and Grafana
echo "Step 8: Deploying Prometheus and Grafana"
cd ./Script
sudo chmod +x install_prometheus\&grafana.sh
./install_prometheus\&grafana.sh


echo "Step 8: Granting permissions to the user, this will take aproximatelly 40 seconds"
sleep 40s
kubectl exec -it $(kubectl get pods -l app=mysql -o jsonpath="{.items[0].metadata.name}") -- mysql -u root -p"$root_password" --execute="GRANT ALL PRIVILEGES ON *.* TO '$user'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"

echo "Deployment completed successfully!"
