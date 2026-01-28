targetScope = 'resourceGroup'

param projectName string
param location string
param environment string
param customerCode string

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


// create vnet
module vnetModule 'modules/vnet.bicep' = {
  name:'vnet-${projectName}-${environment}'
params: {
  location: location
  tags: tags
  vnetParam: vnetParam
  defaultNsgRules: defaultNsgRules
  }
} 

