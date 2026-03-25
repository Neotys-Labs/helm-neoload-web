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

## Migrating from nginx ingress controller to Traefik

The nginx ingress controller has reached end of life. Starting with this chart version, **Traefik** is the default and recommended ingress controller.

### Migration options

#### Option 1: Full migration (recommended)

Update your `values-custom.yaml`:

1. Change `ingress.className` from `nginx` to `traefik`
2. Remove all nginx-specific annotations from `ingress.annotations`:
   - `nginx.ingress.kubernetes.io/ssl-redirect`
   - `nginx.ingress.kubernetes.io/force-ssl-redirect`
   - `nginx.ingress.kubernetes.io/configuration-snippet`
   - `nginx.ingress.kubernetes.io/proxy-body-size`
   - Any other `nginx.ingress.kubernetes.io/*` annotations

Traefik uses sensible defaults that match the previous nginx behavior (no body size limit, no forced SSL redirect when TLS is not configured).

#### Option 2: Traefik with nginx compatibility mode

If you prefer a gradual migration or have complex nginx annotations, Traefik supports an nginx annotation compatibility mode. This allows you to keep your existing nginx annotations while using the Traefik ingress controller.

To enable this mode, configure your Traefik installation with the nginx ingress class provider:

```yaml
# In your Traefik Helm values
providers:
  kubernetesIngress:
    ingressClass: nginx
```

For detailed instructions, see the official Traefik migration guide: [Migrate from ingress-nginx to Traefik](https://traefik.io/blog/migrate-from-ingress-nginx-to-traefik-now)

> [!NOTE]
> The compatibility mode is intended as a transitional solution. We recommend eventually migrating to native Traefik annotations for full feature support.

## Steps

```bash
helm repo update
```

```bash
helm upgrade my-release neotys/nlweb -n my-namespace -f ./values-custom.yaml
```

> **Hint** : If something goes wrong when upgrading, you can use the `helm rollback my-release -n my-namespace` command to rollback
