@description('Azure Container Registry name')
param registryName string

@description('Location for the Container Registry')
param location string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: registryName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

@description('Container Registry login server')
output loginServer string = containerRegistry.properties.loginServer

@description('Container Registry admin username')
@secure()
output username string = containerRegistry.listCredentials().username

@description('Container Registry admin password')
@secure()
output password string = containerRegistry.listCredentials().passwords[0].value
