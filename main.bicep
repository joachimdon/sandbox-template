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
param virtualLinkList array
param defaultNsgRules array

// Create NSGs for each subnet
resource nsgs 'Microsoft.Network/networkSecurityGroups@2023-11-01' = [for (subnet, i) in vnetParam.subnets: {
  name: 'nsg-${subnet.name}'
  location: location
  tags: tags
  properties: {
    securityRules: union(defaultNsgRules, subnet.securityRules)
  }
}]

// Create Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetParam.name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: vnetParam.addressPrefixes
    }
    subnets: [for (subnet, i) in vnetParam.subnets: {
      name: subnet.name
      properties: {
        addressPrefixes: subnet.addressPrefixes
        networkSecurityGroup: {
          id: nsgs[i].id
        }
        serviceEndpoints: subnet.serviceEndpoints
        delegations: !empty(subnet.delegation) ? [
          {
            name: subnet.delegation
            properties: {
              serviceName: subnet.delegation
            }
          }
        ] : []
        privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
        privateLinkServiceNetworkPolicies: subnet.privateLinkServiceNetworkPolicies
      }
    }]
  }
}
