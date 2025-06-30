param containerAppName string = 'my-container-app'
param environmentName string 
param acrName string
param acrResourceGroup string
param location string = resourceGroup().location
param uamiName string = 'my-container-app-uami'
param containerImage string
param envVars array = [
  {
    name: 'ENVIRONMENT'
    value: 'production'
  }
]

// module acr './modules/acr.bicep' = {
//   name: 'acrModule'
//   params: {
//     name: registryName
//     location: location
//   }
// }

// module logAnalyticsModule './modules/logAnalytics.bicep' = {
//   name: 'logAnalytics'
//   params: {
//     name: '${containerAppName}-logs'
//     location: location
//   }
// }

// module envModule './modules/containerAppEnv.bicep' = {
//   name: 'containerAppEnv'
//   params: {
//     name: environmentName
//     location: location
//     logAnalyticsCustomerId: logAnalyticsModule.outputs.customerId
//     logAnalyticsSharedKey: logAnalyticsModule.outputs.sharedKey
//   }
// }

resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01' existing = {
  name: acrName
}

resource containerEnv 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: environmentName
  scope: resourceGroup(acrResourceGroup)
}

var acrLoginServer = '${acr.name}.azurecr.io'


module appModule './modules/containerApp.bicep' = {
  name: 'containerApp'
  params: {
    name: containerAppName
    location: location
    image: containerImage
    environmentId: containerEnv.id
    acrResourceId: acr.id
    envVars: envVars
    uamiName: uamiName
    acrName:acr.name
    acrResourceGroup:acrResourceGroup

  }
}


