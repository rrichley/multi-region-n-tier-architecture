resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'secondary-region-sql-server'
  location: resourceGroup().location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: 'P@ssw0rd123!'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: 'secondary-region-database'
  parent: sqlServer
  properties: {
    sku: {
      name: 'S1'
      tier: 'Standard'
    }
  }
}
