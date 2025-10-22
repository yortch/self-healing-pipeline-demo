metadata description = 'Main orchestration template for Self-Healing Pipeline Demo infrastructure'
metadata author = 'Self-Healing Pipeline Demo'

targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment for naming resources')
param environmentName string

@description('Primary location for resources')
param location string = 'eastus'

@description('Container image URI in Azure Container Registry')
param containerImageUri string = ''

@description('Container app name')
param containerAppName string = 'app-${uniqueString(subscription().id, environmentName)}'

@description('Azure Container Registry name (must be globally unique)')
param acrName string = 'acr${uniqueString(subscription().id, environmentName)}'

@description('Resource group name')
param resourceGroupName string = 'rg-${environmentName}-${uniqueString(subscription().id, environmentName)}'

// Variables
var resourceTokenSuffix = uniqueString(subscription().id, environmentName)
var containerAppEnvironmentName = 'cae-${environmentName}-${resourceTokenSuffix}'
var logAnalyticsWorkspaceName = 'law-${environmentName}-${resourceTokenSuffix}'

// Create resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

// Create Log Analytics Workspace
module logAnalyticsWorkspace 'modules/logAnalytics.bicep' = {
  name: 'logAnalyticsWorkspace'
  scope: resourceGroup
  params: {
    workspaceName: logAnalyticsWorkspaceName
    location: location
  }
}

// Create Container App Environment
module containerAppEnvironment 'modules/containerAppEnvironment.bicep' = {
  name: 'containerAppEnvironment'
  scope: resourceGroup
  params: {
    environmentName: containerAppEnvironmentName
    location: location
    logAnalyticsWorkspaceId: logAnalyticsWorkspace.outputs.workspaceId
    logAnalyticsWorkspaceKey: logAnalyticsWorkspace.outputs.primarySharedKey
  }
}

// Create Azure Container Registry
module containerRegistry 'modules/containerRegistry.bicep' = {
  name: 'containerRegistry'
  scope: resourceGroup
  params: {
    registryName: replace(acrName, '-', '')
    location: location
  }
}

// Create Container App
module containerApp 'modules/containerApp.bicep' = {
  name: 'containerApp'
  scope: resourceGroup
  params: {
    containerAppName: containerAppName
    location: location
    containerAppEnvironmentId: containerAppEnvironment.outputs.environmentId
    containerRegistryLoginServer: containerRegistry.outputs.loginServer
    containerRegistryUsername: containerRegistry.outputs.username
    containerRegistryPassword: containerRegistry.outputs.password
    containerImageUri: containerImageUri
    environmentName: environmentName
  }
}

// Outputs
@description('Resource group name')
output resourceGroupName string = resourceGroup.name

@description('Container App name')
output containerAppName string = containerApp.outputs.name

@description('Container App FQDN')
output containerAppFqdn string = containerApp.outputs.fqdn

@description('Container Registry login server')
output acrLoginServer string = containerRegistry.outputs.loginServer

@description('Container Registry name')
output acrName string = replace(acrName, '-', '')

@description('Container App Environment ID')
output containerAppEnvironmentId string = containerAppEnvironment.outputs.environmentId

@description('Log Analytics Workspace ID')
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.outputs.workspaceId
