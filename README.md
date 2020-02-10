# Neoload Web

[Neoload Web](https://www.neotys.com/neoload/overview) is a performance testing software for all team members from Centers of Excellence to DevOps organizations.

## Introduction

This chart deploys Neoload Web on your kubernetes cluster.

This chart is meant for advanced kubernetes/helm users as a successful installation and exploitation of the application is very environment dependant.

## Prerequisites

- A running [Kubernetes](https://kubernetes.io/) cluster (1.14+)
- [Helm](https://helm.sh/docs/intro/install/) CLI  (~3.0.2)
- A running [mongodb](https://www.mongodb.com/) accessible from the kubernetes cluster ([see supported versions](https://www.neotys.com/documents/doc/nlweb/latest/en/html/#26054.htm#o39020))
- One of the following ingress controller installed on your kubernetes cluster

#### Ingress controller

There are many different ingress controller providers.

This chart has been tested and is shipped with default values for both [**nginx**](https://hub.helm.sh/charts/bitnami/nginx) and [**alb**](https://hub.helm.sh/charts/incubator/aws-alb-ingress-controller).

You can find detailed documentation for ingresses annotations and parameters here :

- [nginx](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/)
- [alb](https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/ingress/annotation/)

> **Caution**: Selecting any other ingress controllers may require additional chart tuning from your part.

## Installation

1. Download and set up your **[values-custom.yaml](/nlweb/values-custom.yaml)** file
2. Install with the following command

```bash		
helm install my-release stable/nlweb -f ./values-custom.yaml
```

## Uninstalling the Chart

To uninstall the `my-release` deployment:

```bash
$ helm uninstall my-release
```

## Configuration

Parameter | Description | Default
----- | ----------- | -------
`image.backend.repository` | The backend image repository to pull from | `neotys/neoload-web-backend`
`image.backend.pullPolicy` | The backend image pull policy | `IfNotPresent`
`image.frontend.repository` | The frontend image repository to pull from | `neotys/neoload-web-backend`
`image.frontend.pullPolicy` | The frontend image pull policy | `IfNotPresent`
`imagePullSecrets` | The image pull secrets | `[]`
 |  | 
`serviceAccount.create` | Specifies whether a service account should be created | `true`
`serviceAccount.name` | The name of the service account to use | 
 |  | 
`podSecurityContext`| The pod security context | `{}`
`securityContext` | The security context | `{}`
 |  | 
`services.webapp.host` | The hostname for the webapp/front deployment | 
`services.webapp.type` | The service type for the webapp/front deployment | `ClusterIP`
`services.webapp.port` | The service port for the webapp/front deployment | `80`
`services.webapp.ingress.paths` | The path mapping for the webapp/front ingress | `[""]`
`services.api.host` | The hostname for the api deployment | 
`services.api.type` | The service type for the api deployment | `ClusterIP`
`services.api.port` | The service port for the api deployment | `80`
`services.api.ingress.paths` | The path mapping for the api ingress | `[""]`
`services.files.host` | The hostname for the files deployment | 
`services.files.type` | The service type for the files deployment | `ClusterIP`
`services.files.port` | The service port for the files deployment | `80`
`services.files.ingress.paths` | The path mapping for the files ingress | `[""]`
 |  | 
`ingress.enabled` | Enable ingresses | `true`
`ingress.class` | Specifies which ingress controller class should listen to this ingress | `nginx`
`ingress.annotations` | Annotations for configuring the ingress | 
`ingress.tls[0].secretName` | The name of your TLS secret | 
`ingress.tls[0].secretCertificate` | The content of your imported certificate | `{}`
`ingress.tls[0].secretKey` | The content of your imported private key | 
 |  | 
`resources.backend.requests.cpu` | CPU resource requests for the backend | `500m`
`resources.backend.requests.memory` | Memory resource requests for the backend | `2Gi`
`resources.backend.limits.cpu` | CPU resource requests for the backend | `2`
`resources.backend.limits.memory` | Memory resource requests for the backend | `3Gi`
`resources.frontend.requests.cpu` | CPU resource requests for the frontend | `500m`
`resources.frontend.requests.memory` | Memory resource requests for the frontend | `900Mi`
`resources.frontend.limits.cpu` | CPU resource requests for the frontend | `2`
`resources.frontend.limits.memory` | Memory resource requests for the frontend | `2Gi`
 |  | 
`neoload.configuration.backend.mongo.host` | MongoDB host | 
`neoload.configuration.backend.mongo.port` | MongoDB port | `27017`
`neoload.configuration.backend.mongo.poolSize` | MongoDB pool size | `50`
`neoload.configuration.backend.java.xmx` | Java JVM Max heap size for the backend | `1800m`
`neoload.configuration.backend.misc.files.maxUploadSizeInBytes` | Max file upload size in bytes | `250000000`
`neoload.configuration.backend.misc.files.maxUploadPerWeek` | Max file upload count per week | `250`
`neoload.configuration.frontend.java.xmx` | Java JVM Max heap size for the frontend | `900m`
 |  | 
`mongodb.usePassword` | Set to false if your MongoDB connection doesn't require authentication | `true`
`mongodb.mongodbUsername` | MongoDB Username | 
`mongodb.mongodbPassword` | MongoDB Password | 
 |  | 
`nodeSelector` | Node Selector | `{}`
`tolerations` | Pod's tolerations | `[]`

We suggest you maintain your own *values-custom.yaml* and update it with your relevant parameters, but you can also specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
    --set ingress.tls=[] \
    stable/nlweb
```

## TLS

To enable TLS and access Neoload Web via https, the parameters :

- `ingress.enabled` must be true
- `ingress.tls` must contain at least one item with the tls secret data

> **Caution**: Ingresses support multiple TLS mapped to respective hosts and paths. This feature is not supported for Neoload Web, i.e. exactly zero or one TLS configuration is expected.

### Using an existing tls secret

Simply refer to your secret in the `ingress.tls[0].secretName` parameter, and leave both `ingress.tls[0].secretCertificate` and `ingress.tls[0].secretKey` empty.

### Creating a new tls secret

#### Provide a certificate and a private key

Use the following documentation or use your own means to provide both a certificate and a private key.

- [Kubernetes TLS Secret generation documentation](https://kubernetes.github.io/ingress-nginx/user-guide/tls/)

#### Add these to your custom values file

Copy the content of the files into the `ingress.tls[0].secretCertificate` and `ingress.tls[0].secretKey` parameters.

#### Specify your new tls secret name

Set a name for your new tls secret name into the `ingress.tls[0].secretName` parameter.