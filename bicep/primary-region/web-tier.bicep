@secure()
param adminPassword string

param adminUsername string

resource availabilitySet 'Microsoft.Compute/availabilitySets@2021-07-01' = {
  name: 'web-tier-availability-set'
  location: resourceGroup().location
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 5
  }
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'web-tier-public-ip'
  location: resourceGroup().location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource lb 'Microsoft.Network/loadBalancers@2021-02-01' = {
  name: 'web-tier-load-balancer'
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

resource webNic 'Microsoft.Network/networkInterfaces@2021-02-01' = [for i in range(3): {
  name: 'web-nic-${i}'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'primary-region-vnet', 'web-subnet')
          }
        }
      }
    ]
  }
}]

resource webVms 'Microsoft.Compute/virtualMachines@2021-07-01' = [for i in range(3): {
  name: 'web-vm-${i}'
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'web-vm-${i}'
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
          id: webNic[i].id // Symbolic reference for the network interface
        }
      ]
    }
    availabilitySet: {
      id: availabilitySet.id
    }
  }
}]
