param name string
param location string
param retentionInDays int = 30

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
  }
}

output workspaceId1 string = logAnalytics.id
output customerId string = logAnalytics.properties.customerId
output sharedKey string = listKeys(logAnalytics.id, logAnalytics.apiVersion).primarySharedKey
