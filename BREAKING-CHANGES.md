# Breaking Changes — Values Impact (3.0.0)

Only changes that affect the values file schema/keys are listed.

## Mandatory changes

- Remove ingress rewrite annotations from your values: `haproxy.router.openshift.io/rewrite-target`, `nginx.ingress.kubernetes.io/rewrite-target`. If you use another ingress (e.g., Traefik, HAProxy Ingress, AWS ALB, Istio), remove any equivalent rewrite settings. Keeping them may cause routing issues with this chart.

## Optional changes

- Remove `neoload.configuration.frontend.java.xmx` (and the `neoload.frontend.java` block). The new frontend ignores these values.
- Remove `neoload.configuration.misc.trackingUrl`. This value is no longer read by the chart.
- New optional keys: `services.api-v4.*`, `extra.hosts.api-v4` (backward compatible; not required).
- Remove NGINX sticky sessions annotations from `ingress.annotations` if present (`nginx.ingress.kubernetes.io/affinity`, `nginx.ingress.kubernetes.io/affinity-mode`, `nginx.ingress.kubernetes.io/session-cookie-*`). These were used for v2 but are not required with v3. Removing them can improve performance and scaling in HA deployments; keep only if you have a strict session stickiness requirement. If you use another ingress controller (e.g., Traefik, HAProxy Ingress, AWS ALB, Istio), remove any equivalent sticky-session settings as well.
