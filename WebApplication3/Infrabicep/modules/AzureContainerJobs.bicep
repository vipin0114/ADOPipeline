@description('Name of the Container Apps Environment')
param environmentName string

@description('Name of the Container App Job')
param jobName string

@description('Location for the resources')
param location string = resourceGroup().location

@description('Container image to run')
param containerImage string

@description('Container image to run')
param containerEnvResourceGroup string


resource containerEnv 'Microsoft.App/managedEnvironments@2023-05-01' existing = {
  name: environmentName 
  scope: resourceGroup(containerEnvResourceGroup)
}

resource containerJob 'Microsoft.App/jobs@2023-05-01' = {
  name: jobName
  location: location
  properties: {
    configuration: {
      triggerType: 'Manual'
      manualTriggerConfig: {
        parallelism: 1
        replicaCompletionCount: 1
      }
      replicaRetryLimit: 1
      replicaTimeout: 300
      scheduleTriggerConfig: null
    }
    environmentId: containerEnv.id
    template: {
      containers: [
        {
          name: 'job-container'
          image: containerImage
          resources: {
            cpu: 0.5
            memory: '1.0Gi'
          }
        }
      ]
    }
  }
}


output jobId string = containerJob.id
