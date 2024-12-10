$resourceGroupName = "example-resources"
$aksClusterName = "kubcluster"

# Service Principal details
$tenantId = "0445e55b-f7a0-4e29-8ac8-cfdc567f002d"
$clientId = "6a93574e-0e57-41a9-be6d-01388330def5"
$clientSecret = "H9A8Q~7M9K5Yr2XuKaY9o_03nhurVfQ5W2SKocgn"

$subscriptionId = "3df65eaa-59b3-426d-9cdf-66bac9179e7f"
 
# Log in using ARM service connection
az login --service-principal --username $clientId --password $clientSecret --tenant $tenantId
 
# Set the subscription
az account set --subscription $subscriptionId
 
# Get the health status of AKS nodes
$aksNodes = az aks nodepool list --resource-group $resourceGroupName --cluster-name $aksClusterName | ConvertFrom-Json
 
$nodeHealth = $true
 
foreach ($node in $aksNodes) {
    if ($node.provisioningState -ne "Succeeded") {
        $nodeHealth = $false
       
    }
}
 
# Get the health status of AKS pods
$pods = kubectl get pods --all-namespaces -o json | ConvertFrom-Json
 
$podHealth = $true
 
foreach ($pod in $pods.items) {
    if ($pod.status.phase -ne "Running" -and $pod.status.phase -ne "Succeeded") {
        $podHealth = $false
       
    }
}
 
# Check health and exit build if any issue is found
if (-not $nodeHealth -or -not $podHealth) {
    Write-Output "One or more AKS resources are unhealthy. Resource Group: $resourceGroupName, Cluster Name: $aksClusterName. Check the Azure DevOps pipeline logs for details."
   
} else {
    Write-Output "resources are healthy."
}








