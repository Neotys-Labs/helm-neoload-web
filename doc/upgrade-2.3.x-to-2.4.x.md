# Upgrading from nlweb-helm chart 2.3.x to 2.4.x

*Before you proceed, make sure you've read on our general [Upgrade](../README.md#Upgrade) section.* 

### Configuration

- You can now use a mongodb connection string in the `neoload.configuration.backend.mongo.host` settings, more information [here](../README.md#mongodb-configuration).
- The `neoload.configuration.proxy` settings has been deprecated, as you must now manage your proxies on the NeoLoad Web settings page.

## Steps

```bash		
helm repo update
```

```bash		
helm upgrade my-release neotys/nlweb -n my-namespace -f ./values-custom.yaml
```

> **Hint** : If something goes wrong when upgrading, you can use the `helm rollback my-release -n my-namespace` command to rollback
