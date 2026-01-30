targetScope = 'subscription'

param projectName string
param location string
param environment string
param customerCode string
param portfolioSubscriptionId string

//tagging
param intilityManaged string
param intilityMonitored string
param intilityBackup string
param deploymentModel string
param IntilityImplementationGuid string
param deployer string

var tags = {
  intilityManaged: intilityManaged
  intilityMonitored: intilityMonitored
  intilityBackup: intilityBackup
  deploymentModel: deploymentModel
  intilityImplementationGuid: IntilityImplementationGuid
  deployer: deployer
}

//networking
param vnetParam object
param defaultNsgRules array

// Create resource group reference

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  scope: subscription(portfolioSubscriptionId)
  name: 'rg-aa387-sandbox'
}

module vnet 'br/public:avm/res/network/virtual-network:0.7.2' = {
  scope: resourceGroup
  name: 'vnet-deploy'
  params: {
    name: 'vnet-${projectName}-${environment}'
    addressPrefixes: vnetParam.addressPrefixes
    subnets: vnetParam.subnets
    location: location
    tags: tags
  }
}

// Deploy Key Vault module

module keyVault 'br:crpclazmodules.azurecr.io/res/key-vault/vault:0.1.0' =  {
  scope: resourceGroup
  name : 'keyvault-deploy'
  params: {
    name: 'kv-aa387-${projectName}-${environment}'
    tags: tags
    location: location
    sku: 'standard'
  }
}
