resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'primary-region-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16' // Address space for the virtual network
      ]
    }
    subnets: [
      {
        name: 'web-subnet' // Subnet for web tier
        properties: {
          addressPrefix: '10.0.1.0/24' // Ensure this value is valid and within the address space
        }
      }
      {
        name: 'app-subnet' // Subnet for application tier
        properties: {
          addressPrefix: '10.0.2.0/24' // Ensure this value is valid and within the address space
        }
      }
      {
        name: 'db-subnet' // Subnet for database tier
        properties: {
          addressPrefix: '10.0.3.0/24' // Ensure this value is valid and within the address space
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'primary-region-nsg'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-HTTPS'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 200
          direction: 'Inbound'
        }
      }
    ]
  }
}

// Associate NSG with web-subnet
resource nsgAssoc 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  name: 'web-subnet'
  parent: vnet
  properties: {
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}
