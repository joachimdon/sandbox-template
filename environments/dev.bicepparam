using '../main.bicep'

param projectName = 'Sandbox'
param location = 'norwayeast'
param environment = 'dev'
param customerCode = 'XX'

// Adjust tags
param intilityManaged = 'false'
param intilityMonitored = 'false'
param intilityBackup = 'false'
param deploymentModel = 'IAC'
param IntilityImplementationGuid = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' // Set Guid
param deployer = 'Intility'

//DNS sones will be linked to the vnet
param virtualLinkList = [
  //'privatelink.azurewebsites.net'
]

param defaultNsgRules = [
  {
    name: 'deny-out-internet'
    properties: {
      description: ''
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: '*'
      destinationAddressPrefix: 'Internet'
      access: 'Deny'
      priority: 910
      direction: 'Outbound'
      sourcePortRanges: []
      destinationPortRanges: []
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
    }
  }
  {
    name: 'deny-in-internet'
    properties: {
      description: ''
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: 'Internet'
      destinationAddressPrefix: '*'
      access: 'Deny'
      priority: 920
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
    }
  }
  {
    name: 'deny-from-vnet'
    properties: {
      description: ''
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: '*'
      access: 'Deny'
      priority: 930
      direction: 'Inbound'
      sourcePortRanges: []
      destinationPortRanges: []
      sourceAddressPrefixes: []
      destinationAddressPrefixes: []
    }
  }
]

param vnetParam = {
  name: 'vnet-${projectName}-${environment}'
  addressPrefixes: [''] //['10.0.0.0/26'] Change ip address
  subnets: [
    {
      name: 'snet-**-${environment}' // Change name
      addressPrefixes: ['']//['10.0.0.0/28'] Change ip address
      securityRules: [
        //Example nsg rule
        /*  {
          name: 'AllowCidrBlockCustomAnyInbound'
          properties: {
            description: 'AllowCidrBlockCustomAnyInbound'
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '*'
            sourceAddressPrefix: ''
            destinationAddressPrefix: ''
            access: 'Allow'
            priority: 100
            direction: 'Inbound'
            sourcePortRanges: []
            destinationPortRanges: []
            sourceAddressPrefixes: [
              ''
              ''
            ]
            destinationAddressPrefixes: []
          }
        }
        */
      ]
      serviceEndpoints: []
      delegation: ''
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
      routeTableRoutes: []
    }
  ]
}
