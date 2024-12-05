resource trafficManager 'Microsoft.Network/trafficManagerProfiles@2020-11-01' = {
  name: 'multi-region-traffic-manager'
  location: 'global'
  properties: {
    trafficRoutingMethod: 'Priority'
    dnsConfig: {
      relativeName: 'my-app'
      ttl: 60
    }
    monitorConfig: {
      protocol: 'HTTPS'
      port: 443
      path: '/health'
    }
    endpoints: [
      {
        name: 'primary-region-endpoint'
        type: 'Microsoft.Network/trafficManagerProfiles/externalEndpoints'
        properties: {
          target: 'PRIMARY_PUBLIC_IP_PLACEHOLDER' // Replace after deployment
          endpointStatus: 'Enabled'
          priority: 1
        }
      }
      {
        name: 'secondary-region-endpoint'
        type: 'Microsoft.Network/trafficManagerProfiles/externalEndpoints'
        properties: {
          target: 'SECONDARY_PUBLIC_IP_PLACEHOLDER' // Replace after deployment
          endpointStatus: 'Enabled'
          priority: 2
        }
      }
    ]
  }
}
