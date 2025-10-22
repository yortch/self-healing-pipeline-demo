@description('Log Analytics Workspace name')
param workspaceName string

@description('Location for the Log Analytics Workspace')
param location string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

@description('Log Analytics Workspace ID')
output workspaceId string = logAnalyticsWorkspace.id

@description('Log Analytics Workspace Primary Shared Key')
@secure()
output primarySharedKey string = logAnalyticsWorkspace.listKeys().primarySharedKey
