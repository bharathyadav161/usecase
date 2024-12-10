# Define variables
$resourceGroupName = "example-resources"
$aksClusterName = "kubcluster"

# Connect to Azure
Connect-AzAccount -Identity

# Get AKS credentials
$kubeconfig = Get-AzAksCredential -ResourceGroupName $resourceGroupName -Name $aksClusterName -Admin -Format 'AzureCli'
$env:KUBECONFIG = $kubeconfig.KubeConfigPath

# Check Nodes
Write-Output "Checking AKS Nodes..."
kubectl get nodes

# Check Pods
Write-Output "Checking AKS Pods..."
kubectl get pods --all-namespaces

# Check Services
Write-Output "Checking AKS Services..."
kubectl get services --all-namespaces

# Check for any issues in Pods
Write-Output "Checking for any issues in Pods..."
kubectl get pods --all-namespaces -o json | ConvertFrom-Json | % {
    $_.items | % {
        $podStatus = $_.status.conditions | ? { $_.type -eq 'Ready' }
        if ($podStatus.status -ne 'True') {
            Write-Output "Pod '$($_.metadata.name)' in namespace '$($_.metadata.namespace)' is not ready"
        }
    }
}

# Check for any issues in Nodes
Write-Output "Checking for any issues in Nodes..."
kubectl get nodes -o json | ConvertFrom-Json | % {
    $_.items | % {
        $nodeStatus = $_.status.conditions | ? { $_.type -eq 'Ready' }
        if ($nodeStatus.status -ne 'True') {
            Write-Output "Node '$($_.metadata.name)' is not ready"
        }
    }
}

Write-Output "AKS Health Check Complete."
