param adminUsername string
param adminPassword string

resource appLb 'Microsoft.Network/loadBalancers@2021-02-01' = {
  name: 'app-tier-load-balancer-secondary'
  location: resourceGroup().location
  properties: {
    frontendIPConfigurations: [
      {
        name: 'frontend-config'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Network/virtualNetworks/secondary-region-vnet/subnets/app-subnet'
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'backend-pool'
      }
    ]
  }
}

resource appVmss 'Microsoft.Compute/virtualMachineScaleSets@2021-07-01' = {
  name: 'app-tier-vmss-secondary'
  location: resourceGroup().location
  sku: {
    name: 'Standard_B2s'
    capacity: 3
  }
  properties: {
    upgradePolicy: {
      mode: 'Automatic'
    }
    virtualMachineProfile: {
      osProfile: {
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      storageProfile: {
        osDisk: {
          createOption: 'FromImage'
        }
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'app-tier-nic'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'ipconfig1'
                  properties: {
                    subnet: {
                      id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Network/virtualNetworks/secondary-region-vnet/subnets/app-subnet'
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: appLb.properties.backendAddressPools[0].id
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}
