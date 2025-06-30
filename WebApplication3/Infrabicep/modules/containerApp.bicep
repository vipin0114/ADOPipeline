param name string
param location string
param image string
param environmentId string
param acrResourceId string
param cpu string  = '0.5'
param memory string  = '1.0'
param targetPort int = 8080
param envVars array = []
param uamiName string
param acrName string
param acrResourceGroup string



resource uami 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: uamiName
  location: location
}

var acrLoginServer = '${acr.name}.azurecr.io'

resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: name
  location: location
 identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uami.id}': {}
    }
  }
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      ingress: {
        external: true
        targetPort: targetPort
        transport: 'auto'
      }
      registries: [
    {
    server: acrLoginServer
    identity: uami.id
    }
    ]
      activeRevisionsMode: 'Single'
    }
    template: {
      containers: [
        {
          name: name
          image: image
          resources: {
            cpu: cpu
            memory: '${memory}Gi'
          }
          env: envVars
        }
      ]
    }
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01' existing = {
  name: acrName
  scope: resourceGroup(acrResourceGroup)
}

module acrRoleAssignment 'assignAcrPullRole.bicep' = {
  name: 'assignAcrPullRole'
  scope: resourceGroup(acrResourceGroup) 
  params: {
    acrName: acrName
    principalId: uami.properties.principalId
  }
}



// resource acrPullRole 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: guid(subscription().id, resourceGroup().name,'AcrPull')
//   scope: acr
//   properties: {
//     roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d') // AcrPull
//     principalId:  uami.properties.principalId
//     principalType: 'ServicePrincipal'
//   }
//   dependsOn: [
//     acr
//     uami
//   ]
// }
