# Upgrading from nlweb-helm chart 4.2.x to 2023.1.x

*Before you proceed, make sure you've read on our general [Upgrade](../README.md#Upgrade) section.* 

## Configuration

A new mandatory parameter is to add in your values custom file :

```yaml
domain: .my-company-name.com

```
This parameter is used for cookies purpose, especially if you try to access API link in the Front like for the Audit feature.
This parameter is now mandatory and the deployment will fail if it is not set.

## Steps

```bash		
helm repo update
```

```bash		
helm upgrade my-release neotys/nlweb -n my-namespace -f ./values-custom.yaml
```

> **Hint** : If something goes wrong when upgrading, you can use the `helm rollback my-release -n my-namespace` command to rollback
