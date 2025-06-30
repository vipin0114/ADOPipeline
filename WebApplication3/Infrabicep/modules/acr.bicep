@description('Name of the Azure Container Registry')
param name string

@description('Location for the registry')
param location string = resourceGroup().location

@description('SKU for ACR: Basic, Standard, Premium')
param sku string = 'Premium'

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: false
  }
}

output acrId string = acr.id
output loginServer string = acr.properties.loginServer
