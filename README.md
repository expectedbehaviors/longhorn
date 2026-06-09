# Longhorn Helm Chart

Wrapper around the [official Longhorn chart](https://charts.longhorn.io) that adds optional custom resources for Longhorn `Node`, `StorageClass`, and `Volume` (+ PV/PVC) rendered from value files.

## What this baseline does

- Deploys Longhorn from the upstream chart (`longhorn:` values).
- Renders custom StorageClasses from `values/storageClasses.yaml`.
- Optional Longhorn Nodes (`values/nodes.yaml`) and Volumes with PV/PVC pairs (`values/volumes.yaml`).
- Optional backup credentials via **onepassworditem** (disabled by default).
- Argo CD sync waves: custom resources use `argocd.argoproj.io/sync-wave: "1"` so they apply after the Longhorn subchart.

## Value files

Merge all value files when templating or deploying:

```yaml
valueFiles:
  - values.yaml
  - values/storageClasses.yaml
  - values/nodes.yaml
  - values/volumes.yaml
```

| File | Purpose |
|------|---------|
| `values.yaml` | Longhorn subchart settings, ingress, backup store, onepassworditem |
| `values/storageClasses.yaml` | Longhorn StorageClass definitions |
| `values/nodes.yaml` | Longhorn Node CRs with disk paths and tags |
| `values/volumes.yaml` | Longhorn Volume CRs plus PV/PVC per namespace |

## Key values

| Area | Where | Default |
|------|-------|---------|
| Ingress | `longhorn.ingress.enabled` | `false` |
| Backup target | `longhorn.defaultBackupStore.backupTarget` | `""` (override in your values) |
| Backup secret | `longhorn.defaultBackupStore.backupTargetCredentialSecret` | `""` |
| 1Password sync | `onepassworditem.enabled` | `false` |
| Nodes / volumes | `nodes`, `volumes` | `[]` (populate in your values) |

## Install

```bash
helm repo add expectedbehaviors https://expectedbehaviors.github.io/longhorn
helm install longhorn expectedbehaviors/longhorn \
  -f values.yaml \
  -f values/storageClasses.yaml \
  -f values/nodes.yaml \
  -f values/volumes.yaml \
  -n longhorn-system --create-namespace
```

## Render & validation

```bash
helm dependency update . && helm template longhorn . \
  -f values.yaml \
  -f values/storageClasses.yaml \
  -f values/nodes.yaml \
  -f values/volumes.yaml \
  -n longhorn-system
```

## Argo CD

Point your Application at this repo (path: `.`) with the four value files above. Override nodes, volumes, backup target, ingress host, and onepassworditem items in your private values repo.

## Support this project

I build tools to get the best homelab experience I can from what's available and to grow as a programmer along the way. If you'd like to contribute, donations go toward homelab operating costs and subscriptions that keep this tooling maintained. Optional and appreciated.

[![Donate with PayPal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/donate/?business=9RHVW92WMWQNL&no_recurring=0&item_name=Optional+donations+help+support+Expected+Behaviors%E2%80%99+open+source+work.+Thank+you.&currency_code=USD)
