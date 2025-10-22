@description('Container App Environment name')
param environmentName string

@description('Location for the Container App Environment')
param location string

@description('Log Analytics Workspace ID')
param logAnalyticsWorkspaceId string

@description('Log Analytics Workspace Primary Shared Key')
@secure()
param logAnalyticsWorkspaceKey string

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: environmentName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: reference(logAnalyticsWorkspaceId, '2021-06-01').customerId
        sharedKey: logAnalyticsWorkspaceKey
      }
    }
  }
}

@description('Container App Environment ID')
output environmentId string = containerAppEnvironment.id
