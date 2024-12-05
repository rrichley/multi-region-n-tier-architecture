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
    loadBalancingRules: [
      {
        name: 'app-http-rule'
        properties: {
          frontendIPConfiguration: {
            id: appLb.properties.frontendIPConfigurations[0].id
          }
          backendAddressPool: {
            id: appLb.properties.backendAddressPools[0].id
          }
          protocol: 'Tcp'
          frontendPort: 8080
          backendPort: 8080
          enableFloatingIP: false
        }
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
      storageProfile: {
        osDisk: {
          createOption: 'FromImage'
        }
      }
      osProfile: {
        adminUsername: 'azureuser'
        adminPassword: 'P@ssw0rd123!'
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
