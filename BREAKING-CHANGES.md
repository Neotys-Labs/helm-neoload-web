# Breaking Changes — Values Impact (3.0.0)

Only changes that affect the values file schema/keys are listed.

- Removed: `neoload.configuration.frontend.java.xmx` (and the `neoload.frontend.java` block). The new frontend no longer accepts Java memory tuning. Remove these keys from your values.
- Removed: `neoload.configuration.misc.trackingUrl`. This value is no longer read by the chart. Remove it to avoid confusion.
 - Removed: ingress rewrite annotations (`haproxy.router.openshift.io/rewrite-target`, `nginx.ingress.kubernetes.io/rewrite-target`). These are no longer relevant for this chart and should be deleted from your `ingress.annotations`. If you use a different ingress solution (e.g., Traefik, HAProxy Ingress, AWS ALB, Istio), remove any equivalent rewrite settings as well.


No other value keys were renamed or made mandatory. New keys like `services.api-v4.*` and `extra.hosts.api-v4` were added but are optional and backward compatible.
