resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: 'secondary-region-vnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.1.0.0/16']
    }
    subnets: [
      {
        name: 'web-subnet'
        properties: {
          addressPrefix: '10.1.1.0/24'
        }
      }
      {
        name: 'app-subnet'
        properties: {
          addressPrefix: '10.1.2.0/24'
        }
      }
      {
        name: 'db-subnet'
        properties: {
          addressPrefix: '10.1.3.0/24'
        }
      }
    ]
  }
}
