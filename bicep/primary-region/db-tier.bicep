param adminUsername string
param adminPassword string

resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'primary-region-sql-server'
  location: resourceGroup().location
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: 'primary-region-database'
  parent: sqlServer
  properties: {
    sku: {
      name: 'S1'
      tier: 'Standard'
    }
  }
}
