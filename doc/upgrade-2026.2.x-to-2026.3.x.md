# Upgrading from nlweb-helm chart 2026.2.x to 2026.3.x

*Before you proceed, make sure you've read our general [Upgrade](../README.md#upgrade) section.*

## What's New

- **MCP Server (On-premise)**: NeoLoad Web Helm chart can deploy the MCP Server as a fourth HTTP workload, enabled by default on On-premise installations.

## MCP Server

From chart **2026.3** onward, the chart ships an optional MCP Server Deployment routed at `/mcp-server` on the **API host** (same host as `/v4` by default).

- Default replica count: `replicaCount.mcpServer: 1`
- Disable MCP (remove pod, Service, and dedicated Ingress): `replicaCount.mcpServer: 0`
- Client URL: `https://<api-host>/mcp-server/mcp` (and `/mcp-server/mcp-v2`)
- Default image: `neotys/neoload-web-mcp` (On-premise build; override `image.mcpServer.repository` / `tag` for your registry)

### Ingress timeout

Long-running MCP requests use a **separate** Ingress (`*-ingress-mcp-server`) so a long timeout can apply to `/mcp-server` without affecting `/v4`.

For OpenShift, set for example:

```yaml
ingress:
  mcpServer:
    annotations:
      haproxy.router.openshift.io/timeout: "2000s"
```

See `values-custom-openshift.yaml`. If your ingress controller cannot scope timeouts per Ingress, document the trade-off for your environment (for example a global API-host timeout).

### Environment variables

The MCP pod receives in-cluster ClusterIP URLs for `API_URL` and `FILES_API_URL`, and the public webapp URL for `FRONTEND_URL`. The chart does **not** set `TRACKING_URL`, `MCP_USAGE_TRACKING_KEY`, or runtime `APPLICATION_DISTRIBUTION`.

### Resource planning

Default MCP resources (`resources.mcpServer`): **10m CPU, 125Mi RAM** per pod. Add one pod to your capacity planning when MCP is enabled.
