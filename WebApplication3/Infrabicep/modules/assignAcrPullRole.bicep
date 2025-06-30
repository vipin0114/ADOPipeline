param acrName string
param principalId string

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: acrName
}

resource acrPullRole 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(acr.id,principalId, 'AcrPull')
  scope: acr
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '7f951dda-4ed3-4680-a7ca-43fe172d538d' // AcrPull
    )
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
