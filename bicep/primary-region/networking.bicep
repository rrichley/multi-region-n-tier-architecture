resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'primary-region-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16' // CIDR block for the entire virtual network
      ]
    }
    subnets: [
      {
        name: 'web-subnet'
        properties: {
          addressPrefix: '10.0.1.0/24' // CIDR block for the web subnet
        }
      }
      {
        name: 'app-subnet'
        properties: {
          addressPrefix: '10.0.2.0/24' // CIDR block for the application subnet
        }
      }
      {
        name: 'db-subnet'
        properties: {
          addressPrefix: '10.0.3.0/24' // CIDR block for the database subnet
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

// Attach NSG to web-subnet
resource nsgAssociation 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  name: 'web-subnet'
  parent: vnet
  properties: {
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}
