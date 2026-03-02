# external-services

> **Fork:** This repository is a fork of [t3n/helm-charts](https://github.com/t3n/helm-charts). We maintain only the **external-service** chart here, renamed and extended as **external-services** (multi-service via a `services` list). Original author: [t3n](https://github.com/t3n). We do not claim credit for the original design; only our changes are ours.

---

## Overview

This chart exposes **non-Kubernetes resources** through your ingress controller: any HTTP/HTTPS endpoint that does not run in the cluster (e.g. BMCs, Pi-hole, ESXi, appliances). A single release can define **multiple** such services: each entry in `services` gets its own Service, Endpoints (or ExternalName), and optional Ingress. The upstream [t3n external-service](https://github.com/t3n/helm-charts/tree/master/external-service) chart supports one service per release; this fork adds a `services` list so you do not need to install the chart multiple times.

---

## Prerequisites

- **1Password Connect** (optional): if you use `onepassworditem.enabled: true` to sync TLS or other secrets. The chart depends on [expectedbehaviors/OnePasswordItem-helm](https://github.com/expectedbehaviors/OnePasswordItem-helm); secrets are created in the release namespace (`.Release.Namespace`). Set `onepassworditem.items[]` with `{ item, name, type }` and reference the Secret name in your ingress TLS (e.g. `ingress.tls[].secretName`).

## Values (onepassworditem)

| Key | Description |
|-----|-------------|
| `onepassworditem.enabled` | If `true` (default), the subchart creates OnePasswordItem resources. Set `false` if you supply TLS or other secrets another way. |
| `onepassworditem.items` | List of `{ item, name, type }`. `name` must match the Secret name referenced in your ingress TLS (e.g. `ingress.tls[].secretName`). |

---

## Requirements

| Requirement | Version |
|-------------|---------|
| Kubernetes | >= 1.19 |
| Helm       | 3.x     |

---

## Install

**From this repo (chart at root):**

```bash
# Clone and install with your values
git clone https://github.com/expectedbehaviors/external-services.git
cd external-services
helm install my-external-services . -f my-values.yaml -n my-namespace --create-namespace
```

**From a Helm repo (after we publish):**

```bash
helm repo add expectedbehaviors https://expectedbehaviors.github.io/external-services
helm install my-external-services expectedbehaviors/external-services -f my-values.yaml -n my-namespace --create-namespace
```

With Argo CD or GitOps: point the Application at this repo (path: `.`) and supply your values.

---

## Subcharts

| Subchart | Source | Values prefix | Description |
|----------|--------|---------------|-------------|
| **onepassworditem** | [expectedbehaviors/OnePasswordItem-helm](https://github.com/expectedbehaviors/OnePasswordItem-helm) | `onepassworditem.*` | Optional TLS/other secrets sync into the release namespace. |

All inputs: **`services`** (list of service definitions: name, type, addresses, ports, ingress, externalName), **`onepassworditem.enabled`**, **`onepassworditem.items`**. Defaults: see `values.yaml`; `services: []` installs nothing.

---

## Values (per service)

Each entry in **`services`** follows the [original chart values](https://github.com/t3n/helm-charts/blob/master/external-service/values.yaml). Default: `services: []` (nothing installed).

| Key | Required | Description |
|-----|----------|-------------|
| **`name`** | Yes | Used in resource names when `fullnameOverride` is not set. |
| `nameOverride` | No | Override the name component (default: `name`). |
| `fullnameOverride` | No | Override the full resource name. |
| `type` | No | `ClusterIP` (default) or `ExternalName`. |
| `addresses` | For ClusterIP | List of `{ ip: "..." }`. |
| `ports` | For ClusterIP | List of `{ name, port, protocol?, ingress?: { hosts: [{ host, paths }] } }`. |
| `ingress` | No | `enabled`, `annotations`, `className`, `tls`. |
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

## Template filenames

This chart uses **camelCase plural** template filenames per project conventions: `services.yaml`, `ingresses.yaml`, `endpoints.yaml`. Legacy `service.yaml` and `ingress.yaml` (if present) are duplicates and should be removed from the repo so only the camelCase files remain.

---

## References

| Resource | Link |
|----------|------|
| **Upstream chart** | [t3n/helm-charts/external-service](https://github.com/t3n/helm-charts/tree/master/external-service) |
| **Upstream values** | [external-service/values.yaml](https://github.com/t3n/helm-charts/blob/master/external-service/values.yaml) |
| **Kubernetes Service** | [Service (ClusterIP, ExternalName)](https://kubernetes.io/docs/concepts/services-networking/service/) |
| **Kubernetes Endpoints** | [Endpoints](https://kubernetes.io/docs/concepts/services-networking/service/#endpoints) |
| **Kubernetes Ingress** | [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) |

---

## License

[MIT](LICENSE)
