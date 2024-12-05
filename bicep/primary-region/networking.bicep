// Define the Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'primary-region-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16' // Address space for the entire VNet
      ]
    }
    subnets: [
      {
        name: 'web-subnet' // Subnet for the web tier
        properties: {
          addressPrefix: '10.0.1.0/24' // Ensure a valid CIDR block
        }
      }
      {
        name: 'app-subnet' // Subnet for the application tier
        properties: {
          addressPrefix: '10.0.2.0/24' // Ensure a valid CIDR block
        }
      }
      {
        name: 'db-subnet' // Subnet for the database tier
        properties: {
          addressPrefix: '10.0.3.0/24' // Ensure a valid CIDR block
        }
      }
    ]
  }
}

// Define the Network Security Group
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

// Associate the NSG with the Web Subnet
resource nsgAssoc 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  name: 'web-subnet'
  parent: vnet
  properties: {
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}
