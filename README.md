# Snowflake Proxy Helm Charts

[![Lint and Test Charts](https://github.com/cloudwithdan/tor-snowflake-proxy-helm-chart/actions/workflows/ci.yml/badge.svg)](https://github.com/cloudwithdan/tor-snowflake-proxy-helm-chart/actions/workflows/ci.yml)
[![Release Charts](https://github.com/cloudwithdan/tor-snowflake-proxy-helm-chart/actions/workflows/release-charts.yml/badge.svg)](https://github.com/cloudwithdan/tor-snowflake-proxy-helm-chart/actions/workflows/release-charts.yml)

Helm charts for deploying [Tor Snowflake Proxy](https://snowflake.torproject.org/) on Kubernetes.

## Usage

### Add the Helm Repository

```bash
helm repo add tor-snowflake-proxy https://cloudwithdan.github.io/tor-snowflake-proxy-helm-chart
helm repo update
```

### Install the Chart

```bash
helm install snowflake tor-snowflake-proxy/tor-snowflake-proxy
```

### Install with Custom Values

```bash
helm install snowflake tor-snowflake-proxy/tor-snowflake-proxy \
  --set replicaCount=1 \
  --set autoscaling.enabled=true
```

## Available Charts

| Chart | Description |
|-------|-------------|
| [tor-snowflake-proxy](./charts/tor-snowflake-proxy) | Tor Snowflake Proxy for helping users bypass censorship |

## Development

### Prerequisites

- [Helm](https://helm.sh/docs/intro/install/) v3.x
- [chart-testing](https://github.com/helm/chart-testing) (for linting)
- [kind](https://kind.sigs.k8s.io/) (for local testing)
