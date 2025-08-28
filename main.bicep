@allowed([
  'dev'
  'staging'
  'prod'
])
param environmentType string

param appServiceAppName string = 'meu-app-unico123${uniqueString(resourceGroup().id)}'
var appServicePlanName = 'meu-plano-app-service'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'F1'

param location string = resourceGroup().location

param storageAccountName string = 'toylauch${uniqueString(resourceGroup().id)}'
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  sku: { name: storageAccountSkuName }
  kind: 'StorageV2'
  properties: { accessTier: 'Hot' }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2024-11-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
