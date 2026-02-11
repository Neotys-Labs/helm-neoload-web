# Upgrading from nlweb-helm chart 2025.2.x to 2026.1.x

*Before you proceed, make sure you've read on our general [Upgrade](../README.md#Upgrade) section.*

## What's New

This major chart version introduces significant changes:

- **Next Gen Frontend**: The old Java-based frontend has been replaced by a new lightweight frontend with improved performances and UX.
- **API v4**: A new API version is introduced for improved functionality.

## Changes — Values Impact

Only changes that affect the values file schema/keys are listed.

### Breaking changes

- Remove ingress rewrite annotations from your values: `haproxy.router.openshift.io/rewrite-target`, `nginx.ingress.kubernetes.io/rewrite-target`. If you use another ingress (e.g., Traefik, HAProxy Ingress, AWS ALB, Istio), remove any equivalent rewrite settings. Keeping them may cause routing issues with this chart.

#### Troubleshooting

- If unable to load the app after migration, try clearing your browser cache or use a different browser than usual.

### Optional changes

- Remove `neoload.configuration.frontend.java.xmx` (and the `neoload.frontend.java` block). The new frontend ignores these values.
- Remove `neoload.configuration.misc.trackingUrl`. This value is no longer read by the chart.
- New optional keys: `services.api-v4.*`, `extra.hosts.api-v4` (backward compatible; not required).
- Remove NGINX sticky sessions annotations from `ingress.annotations` if present (`nginx.ingress.kubernetes.io/affinity`, `nginx.ingress.kubernetes.io/affinity-mode`, `nginx.ingress.kubernetes.io/session-cookie-*`). These were used for v2 but are not required with v3. Removing them can improve performance and scaling in HA deployments; keep only if you have a strict session stickiness requirement. If you use another ingress controller (e.g., Traefik, HAProxy Ingress, AWS ALB, Istio), remove any equivalent sticky-session settings as well.

## Steps

```bash
helm repo update
```

```bash
helm upgrade my-release neotys/nlweb -n my-namespace -f ./values-custom.yaml
```

> **Hint** : If something goes wrong when upgrading, you can use the `helm rollback my-release -n my-namespace` command to rollback
