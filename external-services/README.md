# External Services Helm Chart

> **Fork:** This project is a fork of [t3n/helm-charts](https://github.com/t3n/helm-charts) (external-service chart). Original author: [t3n](https://github.com/t3n). We do not claim credit for the original design; only our changes (e.g. schema, behavior) are ours.

Set the repo description (About → description) to e.g. **Fork of t3n/helm-charts. Multi-service external-service chart.**

---

## Overview

This chart exposes **non-Kubernetes resources** through your ingress controller: any HTTP/HTTPS endpoint that does not run in the cluster (e.g. BMCs, Pi-hole, ESXi, appliances). A single release can define **multiple** such services: each entry in `services` gets its own Service, Endpoints (or ExternalName), and optional Ingress. The upstream [t3n external-service](https://github.com/t3n/helm-charts/tree/master/external-service) chart supports one service per release; this fork adds a `services` list so you do not need to install the chart multiple times.

---

## Requirements

| Requirement | Version |
|-------------|---------|
| Kubernetes | >= 1.19 |
| Helm       | 3.x     |

---

## References

| Resource | Link |
|----------|------|
| **Upstream chart** | [t3n/helm-charts/external-service](https://github.com/t3n/helm-charts/tree/master/external-service) |
| **Upstream values** | [external-service/values.yaml](https://github.com/t3n/helm-charts/blob/master/external-service/values.yaml) |
| **Upstream repo** | [t3n/helm-charts](https://github.com/t3n/helm-charts) |
| **Kubernetes Service** | [Service (ClusterIP, ExternalName)](https://kubernetes.io/docs/concepts/services-networking/service/) |
| **Kubernetes Endpoints** | [Endpoints](https://kubernetes.io/docs/concepts/services-networking/service/#endpoints) |
| **Kubernetes Ingress** | [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) |
| **Helm install** | [Helm install](https://helm.sh/docs/helm/helm_install/) |

**Track upstream (compare or pull changes):**

```bash
git remote add upstream https://github.com/t3n/helm-charts.git
git fetch upstream
# Compare: diff against upstream/master, path external-service/
```

---

## Values (per service)

Each entry in **`services`** follows the [original chart’s values](https://github.com/t3n/helm-charts/blob/master/external-service/values.yaml). Default: `services: []` (nothing installed).

| Key | Required | Description |
|-----|----------|-------------|
| **`name`** | Yes | Used in resource names when `fullnameOverride` is not set. |
| `nameOverride` | No | Override the name component (default: `name`). |
| `fullnameOverride` | No | Override the full resource name. |
| `type` | No | `ClusterIP` (default) or `ExternalName`. |
| `addresses` | For ClusterIP | List of `{ ip: "..." }`. |
| `ports` | For ClusterIP | List of `{ name, port, protocol?, ingress?: { hosts: [{ host, paths }] } }`. |
| `ingress` | No | `enabled`, `annotations`, `className`, `tls` (see [Ingress TLS](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls)). |
| `externalName` | For ExternalName | Required when `type: ExternalName`. |

---

## Example: two services (ClusterIP)

```yaml
services:
  - name: bmc
    type: ClusterIP
    addresses:
      - ip: 10.0.0.1
    ports:
      - port: 80
        name: http
        ingress:
          hosts:
            - host: bmc.example.com
              paths: ["/"]
    ingress:
      enabled: true
      annotations: {}

  - name: pihole
    type: ClusterIP
    addresses:
      - ip: 10.0.0.2
    ports:
      - port: 80
        name: http
        ingress:
          hosts:
            - host: pihole.example.com
              paths: ["/"]
    ingress:
      enabled: true
      annotations: {}
```

---

## Example: ExternalName service

```yaml
services:
  - name: external-db
    type: ExternalName
    externalName: db.example.svc.cluster.local
```

---

## Install

```bash
helm install external-services . -f my-values.yaml -n external-services --create-namespace
```

With Argo CD or GitOps: point the Application at this repo and supply your values (e.g. from a private values repo).

---

## Support this project

I build tools to get the best homelab experience I can from what's available and to grow as a programmer along the way. If you'd like to contribute, donations go toward homelab operating costs and subscriptions that keep this tooling maintained. Optional and appreciated.

[![Donate with PayPal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/donate/?business=9RHVW92WMWQNL&no_recurring=0&item_name=Optional+donations+help+support+Expected+Behaviors%E2%80%99+open+source+work.+Thank+you.&currency_code=USD)
