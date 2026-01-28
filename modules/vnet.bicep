param location string
param tags object

//networking
param vnetParam object
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

output vnetId string = vnet.id
output vnetName string = vnet.name
output subnetIds array = [for (subnet, i) in vnetParam.subnets: vnet.properties.subnets[i].id]
