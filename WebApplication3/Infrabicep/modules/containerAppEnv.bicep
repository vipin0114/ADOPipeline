param name string
param location string
// param logAnalyticsCustomerId string
// param logAnalyticsSharedKey string
param containerAppName string


module logAnalyticsModule 'logAnalytics.bicep' = {
  name: 'logAnalytics'
  params: {
    name: '${containerAppName}-logs'
    location: location
  }
}


resource env 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: name
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsModule.outputs.customerId
        sharedKey: logAnalyticsModule.outputs.sharedKey
      }
    }
  }
}




output environmentId string = env.id
