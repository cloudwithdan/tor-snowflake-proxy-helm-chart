# Snowflake Proxy Helm Chart

A Helm chart for deploying [Tor Snowflake Proxy](https://snowflake.torproject.org/) on Kubernetes.

## Introduction

Snowflake is a pluggable transport for Tor that helps users in censored regions bypass internet restrictions. By running a Snowflake proxy, you volunteer bandwidth to help others access the free internet.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Outbound UDP connectivity (for WebRTC/STUN)

## Installation

### Add the chart repository (if published)

```bash
helm repo add my-charts https://charts.example.com
helm repo update
```

### Install from local directory

```bash
helm install snowflake ./snowflake-proxy-helm
```

### Install with custom values

```bash
helm install snowflake ./snowflake-proxy-helm \
  --set replicaCount=5 \
  --set snowflake.verbose=true
```

### Install with a values file

```bash
helm install snowflake ./snowflake-proxy-helm -f my-values.yaml
```

## Uninstallation

```bash
helm uninstall snowflake
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of proxy replicas | `1` |
| `image.repository` | Container image repository | `thetorproject/snowflake-proxy` |
| `image.tag` | Container image tag | `""` (uses appVersion) |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `snowflake.brokerURL` | Snowflake broker URL | `https://snowflake-broker.torproject.net/` |
| `snowflake.relayURL` | Snowflake relay URL | `wss://snowflake.torproject.net/` |
| `snowflake.stunServers` | STUN servers for NAT traversal | `["stun:stun.l.google.com:19302", "stun:stun.voip.blackberry.com:3478"]` |
| `snowflake.verbose` | Enable verbose logging | `false` |
| `snowflake.keepLocalAddresses` | Keep local addresses (debugging) | `false` |
| `snowflake.unsafeLogging` | Log client IPs (debugging only) | `false` |
| `snowflake.capacity` | Max concurrent clients (0=unlimited) | `0` |
| `snowflake.summaryInterval` | Stats interval in seconds | `3600` |
| `resources.limits.cpu` | CPU limit | `{}` |
| `resources.limits.memory` | Memory limit | `{}` |
| `resources.requests.cpu` | CPU request | `{}` |
| `resources.requests.memory` | Memory request | `{}` |
| `podDisruptionBudget.enabled` | Enable PDB | `false` |
| `podDisruptionBudget.minAvailable` | Minimum available pods | `1` |
| `networkPolicy.enabled` | Enable NetworkPolicy | `false` |
| `serviceAccount.create` | Create service account | `true` |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | Tolerations for pod assignment | `[]` |
| `affinity` | Affinity rules for pod assignment | `{}` |

## Examples

### High-availability deployment

```yaml
# ha-values.yaml
replicaCount: 5

podDisruptionBudget:
  enabled: true
  minAvailable: 2

affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              app.kubernetes.io/name: snowflake-proxy
          topologyKey: kubernetes.io/hostname

resources:
  limits:
    cpu: 1000m
    memory: 256Mi
  requests:
    cpu: 200m
    memory: 128Mi
```

### Minimal deployment

```yaml
# minimal-values.yaml
replicaCount: 1

resources:
  limits:
    cpu: 200m
    memory: 64Mi
  requests:
    cpu: 50m
    memory: 32Mi
```

### With NetworkPolicy

```yaml
# secured-values.yaml
networkPolicy:
  enabled: true
```

## Network Requirements

Snowflake proxies need the following outbound connectivity:

| Protocol | Port | Destination | Purpose |
|----------|------|-------------|---------|
| TCP | 443 | Tor broker/relay | HTTPS/WSS connections |
| UDP | 53 | DNS servers | Name resolution |
| UDP | 3478, 19302 | STUN servers | NAT traversal |
| UDP | 30000-32767 | Internet | WebRTC data channels |

## Monitoring

Check logs to verify the proxy is working:

```bash
kubectl logs -l app.kubernetes.io/name=snowflake-proxy --tail=100
```

Expected log messages:
- `connected to the Snowflake broker` - Successfully registered with broker
- `client successfully received` - Helping a censored user
- Traffic statistics (if `summaryInterval` > 0)

## Security Considerations

This chart follows security best practices:

- Runs as non-root user (UID 1000)
- Read-only root filesystem
- Drops all capabilities
- No privilege escalation
- Minimal service account permissions

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This Helm chart is provided under the MIT License.

## Acknowledgments

- [Tor Project](https://www.torproject.org/) for developing Snowflake
- All volunteers who run Snowflake proxies to help others access the free internet