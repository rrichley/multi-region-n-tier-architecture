resource primaryToSecondaryPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: 'primary-to-secondary-peering'
  parent: {
    id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/primary-region-rg/providers/Microsoft.Network/virtualNetworks/primary-region-vnet'
  }
  properties: {
    remoteVirtualNetwork: {
      id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/secondary-region-rg/providers/Microsoft.Network/virtualNetworks/secondary-region-vnet'
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
  }
}

resource secondaryToPrimaryPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: 'secondary-to-primary-peering'
  parent: {
    id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/secondary-region-rg/providers/Microsoft.Network/virtualNetworks/secondary-region-vnet'
  }
  properties: {
    remoteVirtualNetwork: {
      id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/primary-region-rg/providers/Microsoft.Network/virtualNetworks/primary-region-vnet'
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
  }
}
