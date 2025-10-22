@description('Container App name')
param containerAppName string

@description('Location for the Container App')
param location string

@description('Container App Environment ID')
param containerAppEnvironmentId string

@description('Container Registry login server')
param containerRegistryLoginServer string

@description('Container Registry username')
param containerRegistryUsername string

@description('Container Registry password')
@secure()
param containerRegistryPassword string

@description('Container image URI')
param containerImageUri string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

@description('Environment name')
param environmentName string

@description('Tags for the Container App')
var tags = {
  environment: environmentName
}

resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: containerAppName
  location: location
  tags: tags
  identity: {
    type: 'None'
  }
  properties: {
    managedEnvironmentId: containerAppEnvironmentId
    configuration: {
      ingress: {
        external: true
        targetPort: 3000
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
      registries: [
        {
          server: containerRegistryLoginServer
          username: containerRegistryUsername
          passwordSecretRef: 'registrypassword'
        }
      ]
      secrets: [
        {
          name: 'registrypassword'
          value: containerRegistryPassword
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'app'
          image: containerImageUri != '' ? containerImageUri : 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
          probes: [
            {
              type: 'liveness'
              httpGet: {
                path: '/health'
                port: 3000
              }
              initialDelaySeconds: 5
              periodSeconds: 10
            }
            {
              type: 'readiness'
              httpGet: {
                path: '/health'
                port: 3000
              }
              initialDelaySeconds: 5
              periodSeconds: 10
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 3
        rules: [
          {
            name: 'http-requests'
            http: {
              metadata: {
                concurrentRequests: '10'
              }
            }
          }
        ]
      }
    }
  }
}

@description('Container App name')
output name string = containerApp.name

@description('Container App FQDN')
output fqdn string = containerApp.properties.configuration.ingress.fqdn
