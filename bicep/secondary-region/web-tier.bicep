param adminUsername string
param adminPassword string

resource availabilitySet 'Microsoft.Compute/availabilitySets@2021-07-01' = {
  name: 'web-tier-availability-set-secondary'
  location: resourceGroup().location
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 5
  }
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'web-tier-public-ip-secondary'
  location: resourceGroup().location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource lb 'Microsoft.Network/loadBalancers@2021-02-01' = {
  name: 'web-tier-load-balancer-secondary'
  location: resourceGroup().location
  properties: {
    frontendIPConfigurations: [
      {
        name: 'frontend-config'
        properties: {
          publicIPAddress: {
            id: publicIp.id
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

resource webVms 'Microsoft.Compute/virtualMachines@2021-07-01' = [for i in range(3): {
  name: 'web-vm-secondary-${i}'
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'web-vm-secondary-${i}'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Network/networkInterfaces/web-nic-secondary-${i}'
        }
      ]
    }
    availabilitySet: {
      id: availabilitySet.id
    }
  }
}]
