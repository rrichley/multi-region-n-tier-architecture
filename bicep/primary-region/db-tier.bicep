resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: 'primary-region-sql-server'
  location: resourceGroup().location
  properties: {
    administratorLogin: 'sqladmin'
    administratorLoginPassword: 'P@ssw0rd123!'
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

resource failoverGroup 'Microsoft.Sql/servers/failoverGroups@2021-02-01-preview' = {
  name: 'sql-failover-group'
  parent: sqlServer
  properties: {
    partnerServers: [
      {
        id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/secondary-region-rg/providers/Microsoft.Sql/servers/secondary-region-sql-server'
      }
    ]
    readWriteFailoverPolicy: {
      mode: 'Automatic'
    }
  }
}
