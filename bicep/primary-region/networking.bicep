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
        name: 'web-subnet'
        properties: {
          addressPrefix: '10.0.1.0/24' // CIDR block for the web subnet
        }
      }
    ]
  }
}
