# Upgrading from nlweb-helm chart 2.x.x to 2.3.x

*Before you proceed, make sure you've read on our general [Upgrade](../README.md#Upgrade) section.* 

### Configuration

A new set of licensing related features available as of NeoLoad Web v2.11.0 can be enabled by setting up a licensing key in your values file.

Also take note that your NeoLoad Web instance must be able to make external network calls to our public licensing platform. 

We thus provide a new setting if you need to go through your own proxy server.

Here are the keys to add :

```yaml
neoload:
  configuration:
    backend:
      licensingPlatformToken: your-token-goes-here
    proxy:
      https: https://username:password@host:port

```

## Steps

```bash		
helm repo update
```

```bash		
helm upgrade my-release neotys/nlweb -n my-namespace -f ./values-custom.yaml
```

> **Hint** : If something goes wrong when upgrading, you can use the `helm rollback my-release -n my-namespace` command to rollback