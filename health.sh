     #!bin/bash
     set -e
 
    # Install Azure CLI
    echo "Installing Azure CLI..."
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
 
    # Install kubectl
    echo "Installing kubectl..."
    sudo az aks install-cli
 
    # Variables
    AZURE_SUBSCRIPTION_ID="3df65eaa-59b3-426d-9cdf-66bac9179e7f"
    AZURE_TENANT_ID="0445e55b-f7a0-4e29-8ac8-cfdc567f002d"
    AZURE_CLIENT_ID="6a93574e-0e57-41a9-be6d-01388330def5"
    AZURE_CLIENT_SECRET="H9A8Q~7M9K5Yr2XuKaY9o_03nhurVfQ5W2SKocgn"
    RESOURCE_GROUP="example-resources"
    AKS_CLUSTER_NAME="kubcluster"
 
    # Login to Azure using service principal
    echo "Logging in to Azure..."
    az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
 
    # Set the subscription
    az account set --subscription $AZURE_SUBSCRIPTION_ID
 
    # Get AKS credentials
    echo "Getting AKS credentials..."
    az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME
 
    # Check AKS nodes
    echo "Checking AKS nodes status..."
    kubectl get nodes -o wide
 
    # Check AKS pods
    echo "Checking AKS pods status..."
    kubectl get pods --all-namespaces -o wide
 
    # Optional: Check AKS services
    echo "Checking AKS services status..."
    kubectl get svc --all-namespaces -o wide
 
    # Optional: Check AKS deployments
    echo "Checking AKS deployments status..."
    kubectl get deployments --all-namespaces -o wide
