targetScope = 'subscription' 

param projectName string
param location string
param environment string
param customerCode string


//xx-management subscription id
param managementSubId string
//xx-connectivity subscription id 
param connectivitySubId string
param rgPrivateDnsName string = 'rg-platform-dns'


//tagging
param intilityManaged string
param intilityMonitored string
param intilityBackup string
param deploymentModel string
param IntilityImplementationGuid string
param deployer string

var tags object = {
  intilityManaged: intilityManaged
  intilityMonitored: intilityMonitored
  intilityBackup: intilityBackup
  deploymentModel: deploymentModel
  intilityImplementationGuid: IntilityImplementationGuid
  deployer: deployer
}

//networking
param vnetParam object
param virtualLinkList array
param defaultNsgRules array


resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'rg-${projectName}-${environment}'
  location: location
  tags: tags
}

module vnet 'br:crpclazmodules.azurecr.io/ptn/virtual-network:0.1.10' = {
  name: 'vnet-deploy'
  params: {
    name: vnetParam.name
    location: location
    tags: tags
    rgName: rg.name
    customerCode: customerCode
    addressPrefixes: vnetParam.addressPrefixes
    subnets: vnetParam.subnets
    platformSubId: managementSubId
    virtualLinkList: virtualLinkList
    defaultNsgRules: defaultNsgRules
    rgPrivateDnsName: rgPrivateDnsName
    subPrivateDnsString: connectivitySubId
  }
}
