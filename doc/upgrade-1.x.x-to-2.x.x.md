# Upgrading from nlweb-helm chart 1.x.x to 2.x.x

*Before you proceed, make sure you've read on our general [Upgrade](../README.md#Upgrade) section.* 

## Prerequisites

### Hardware

The goal of this release is to enable High Availability for NeoLoad Web, and we do so by setting 2 replicas of each components by default. **This will double the amount of resources required**, so before trying to upgrade your chart make sure that your nodes have a capacity such as described in the [main hardware section](../README.md#Hardware).

### Configuration

Default Ingress annotations have been added to the [values.yaml](../values.yaml) file for enabling *sticky sessions* in `nginx ingress controllers`.
**If you are using another type of ingress controller than nginx, you must add the relevant annotations yourself** that will enable *sticky sessions* as well, otherwise your application will not function correctly.

## Steps

```bash		
helm repo update
```

```bash		
helm upgrade my-release neotys/nlweb -n my-namespace -f ./values-custom.yaml
```

> **Hint** : If you want your Deployment to use the same amount of resources as before, you should upgrade with the minimum number of replicas, by adding the following parameters to your helm upgrade command `--set replicaCount.frontend=1,replicaCount.backend=1`

> **Hint** : If something goes wrong when upgrading, you can use the `helm rollback my-release -n my-namespace` command to rollback