# NeoLoad Web

[NeoLoad Web](https://www.neotys.com/neoload/overview) allows testing teams to view, analyze and monitor tests wherever they're running from and wherever the teams are. Enabling real-time access to this information improves anomaly detection by allowing performance trending and simplifying root cause analysis. 

SaaS version is available [here](https://neoload.saas.neotys.com/) 

**Key features**

- Share a centralized view of the tests from anywhere in the world in real time
- Monitor big trends with graphs
- Get a closer look by diving into the details of a test
- Test data is hosted in the NeoLoad Web Cloud: tests can be accessed even when the NeoLoad Controller which launched them is not available

## Introduction

This chart deploys NeoLoad Web on your Kubernetes cluster.

## License

NeoLoad is licensed under the following [License Agreement](https://www.neotys.com/documents/legal/eula/neoload/eula_en.html). You must agree to this license agreement to download and use the image.

> **Note**: This license does not permit further distribution.

## Targeted audience

This chart is meant for experimented Kubernetes/Helm users as a successful installation and exploitation of the application is very environment dependant.

## Prerequisites

### Hardware

NeoLoad Web will require your cluster to run a minimum of 2 pods, hosting the frontend and the backend separately.
Here is a table to let you quickly estimate the resource requirements of your nodes, based on `resources.frontend.*` and `resources.backend.*` [(see Advanced Configuration)](#advanced-configuration).

Deployment | Content | Requests | Limits
----- | ----------- | ----- | -----
Minimal | 1 Frontend Pod, 1 Backend Pod | **2 CPU, 4Gi RAM** | **4 CPU, 5Gi RAM**
Default | 2 Frontend Pods, 2 Backend Pods | **4 CPU, 8Gi RAM** | **8CPU, 10Gi RAM**
Advanced | X Frontend Pods, Y Backend Pods | **X\*1 + Y\*1 CPU, X\*1500 + Y\*2500 Mi RAM** | **X\*2 + Y\*2 CPU, X\*2 + Y\*3 Gi RAM**



### Software

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) CLI
- [Helm](https://helm.sh/docs/intro/install/) CLI  (^3.0.0)
- A running [Kubernetes](https://kubernetes.io/) cluster (1.14.0 - 1.25.0)
- A running [mongodb](https://www.mongodb.com/) accessible from the Kubernetes cluster ([see supported versions](/doc/mongo-prerequisites.md))
- A running ingress controller deployed on the Kubernetes cluster

#### Ingress controller

You can use your favorite [ingress controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) for enabling your ingresses to route external traffic to NeoLoad Web.

This chart is tested, maintained and shipped with default values for the nginx ingress controller.
Supported ingress controllers are: nginx, OpenShift.

You can find documentation for nginx ingress controller [here](https://kubernetes.github.io/ingress-nginx/).
You can find documentation for OpenShift ingress controller [here](https://docs.openshift.com/container-platform/4.7/networking/ingress-operator.html).

Basic configuration options are detailled [here](https://kubernetes.github.io/ingress-nginx/deploy/) and you can find advanced configuration options [here](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/).

> **Caution**: Using another ingress controller may require additional chart tuning from your part.

#### MongoDB Prerequisites

You can find your external MongoDB prerequisites [here](/doc/mongo-prerequisites.md).

#### OpenShift

You have a specific values-custom to ease the deployment of NeoLoad Web on OpenShift: values-custom-openshift.yaml.

In this file you will have to modify the security context parameters to match your cluster rights.
You can find documentation on security context [here](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).

To enable TLS on your routes you should:
- Have a valid certificate.
- Fill your certificate in the values-custom-openshift.yaml file.
- Or reference the name of the secret that holds that certificat.

## Installation

1. Add the Neotys chart repository or update it if you already had it registered

```bash		
helm repo add neotys https://helm.prod.neotys.com/stable/
```

```bash		
helm repo update
```

2. Download and set up your **[values-custom.yaml](/values-custom.yaml)** file

```bash
wget https://raw.githubusercontent.com/Neotys-Labs/helm-neoload-web/master/values-custom.yaml
```
>You can refer to the ['Getting started'](#getting-started) section for basic configuration options.

3. Create a dedicated namespace

```bash		
kubectl create namespace my-namespace
```

4. Install with the following command

```bash		
helm install my-release neotys/nlweb -n my-namespace -f ./values-custom.yaml
```

> Since Helm 3.2+ you can skip step 3, and add the --create-namespace option to this command

## Uninstall

To uninstall the `my-release` deployment:

```bash
$ helm uninstall my-release -n my-namespace
```

## Upgrade

You can use the `helm upgrade` command when you want to :
1. Upgrade your NeoLoad Web installation.
2. Benefit from a newer chart version.
3. Change some values/environment variables in your deployment.

> **Warning** : In that last case, keep in mind that when updating your repositories, you may fetch a new chart/application version that could change your whole deployment. To avoid that, you can add the `--version=x.x.x` to the `helm upgrade` command and force your chart version to remain the same as the one deployed.

```bash		
helm repo update
```

```bash		
helm upgrade my-release neotys/nlweb -n my-namespace -f ./values-custom.yaml
```

### Upgrade guides

The following docs can help you when migrating chart version with breaking changes.

| Targeted versions | Link |
| -------- | ---- | 
| 1.x.x to 2.x.x | [Upgrade Guide](/doc/upgrade-1.x.x-to-2.x.x.md) |
| 2.x.x to 2.3.x | [Upgrade Guide](/doc/upgrade-2.x.x-to-2.3.x.md) |
| 2.3.x to 2.4.x | [Upgrade Guide](/doc/upgrade-2.3.x-to-2.4.x.md) |
| 2.3.x to 2.4.x | [Upgrade Guide](/doc/upgrade-2.3.x-to-2.4.x.md) |
| 4.2.x to 2023.1.x | [Upgrade Guide](/doc/upgrade-4.2.x-to-2023.1.x.md) |

### Version compatibility

Due to Helm Charts nature, there are two distinct version numbers to keep track of :
- NeoLoad Web version
- The Chart version

You should always upgrade ([see the upgrade section](#upgrade)) with the new chart version, as we release a new one for every NeoLoad Web release we make. But you also have the possibility to manage independantly NeoLoad Web version by changing the images tags ([see `image.backend.repository` and `image.frontend.repository`](#advanced-configuration) ).

However you should be aware of the following compatibility table to understand which combinations are supported.

_ | NeoLoad Web Version < 2.9.X | NeoLoad Web Version >= 2.9.X
--|-----------------|-----------------
Chart Version < 2.0.0 | OK | OK
Chart Version >= 2.0.0 | **KO** | OK

## Architecture

This schema describe:
* Components created inside the kubernetes cluster by this chart
* How they interact between them
* How they interact with components outside the cluster:
  * NeoLoad Web UI through a web browser
  * NeoLoad Controller
  * NeoLoad Load Generator
  * Any integration based on NeoLoad Web API
  * MongoDB server

![NeoLoad Web deployment schema](./doc/nlweb-architecture-schema.png)

## High Availability

From versions 2.0.0 of this chart and 2.9.0 of NeoLoad Web, we include a mecanism for **High Availability**. This means you can easily scale your NeoLoad Web frontend/backend, and the application will be more failure tolerant.

> Use `replicaCount.frontend` and `replicaCount.backend` values to arrange your Deployment the way you see fit. We set a default of 2 frontend instances and 2 backend instances so you get a resilient NeoLoad Web application out of the box.

This change has a few impacts on your NeoLoad Web deployment.

- From now on your cluster will need to be able to deploy at least 2 pods (one for frontend and one for backend) instead of 1. Some nodes can restrain the number of simultaneous pods, so you need to make sure it is allowed.
- Your ingress controller needs to support **sticky sessions**, meaning that it can ensure a user is always dispatched to the same frontend instance throughout his session. We provide a basic configuration for nginx in our [values-custom.yaml](/values-custom.yaml) file.
- Some additional cluster roles are required. See [cluster-role.yaml](/templates/cluster-role.yaml).

> Check out the [upgrade section](#upgrade) to learn more about upgrading your chart.

## Configuration

### Getting started

Here is a guide for a quick setup of your `values-custom.yaml` file.

#### MongoDB configuration

##### Host and port

The preferred way to configure MongoDB connection information is to replace `YOUR_MONGODB_HOST_URL` by the
full connection string URI. See [MongoDB official documentation](https://www.mongodb.com/docs/v4.4/reference/connection-string/). <br/>
You must also set `port` to `0`. <br/>
Username and/or password can be provided in the URI, special characters must be URL-encoded. By doing this, you must set `usePassword` to `false` in the below section "Authentication".

```yaml
neoload:
  configuration:
    backend:
      mongo:
        host: YOUR_MONGODB_HOST_URL
        port: 0

```

>**Example:** For MongoDB requiring SSL connection, the `host` value must look like: `mongodb://mongo.mycompany.com:27017/admin?ssl=true`

>**Example:** For MongoDB as a cluster of machines (replica set), the `host` value must look like: `mongodb://rs1.mongo.mycompany.com:27017,rs2.mongo.mycompany.com:27017,rs3.mongo.mycompany.com:27017/admin`

>**Example:** For MongoDB connection with DNS Seedlist Connection Format, the `host` value must look like: `mongodb+srv://rs1.mongo.mycompany.com:27017,rs2.mongo.mycompany.com:27017,rs3.mongo.mycompany.com:27017/admin`

>**Note:** The compatibility with older configurations is kept. The `host` and `port` values can be set to your MongoDB server hostname and port according to your setup.

>**Note:** Other custom connection options are supported, see MongoDB connection string options official documentation [here](https://www.mongodb.com/docs/v4.4/reference/connection-string/).

##### Authentication

Depending on your mongoDB setup you must specify if an authentication is required or not. There are two options:

- Either set user info directly in the URI (see above section "Host and port")
- Or set `usePassword` to `true` and replace the `YOUR_MONGODB_USER` and `YOUR_MONGODB_PASSWORD` placeholders accordingly in below example.

```yaml
### MongoDB user configuration
mongodb:
  usePassword: true
  mongodbUsername: YOUR_MONGODB_USER
  mongodbPassword: YOUR_MONGODB_PASSWORD
```



#### NeoLoad Web secret key

The NeoLoad Web secret key is used to encrypt and decrypt the passwords that are stored by NeoLoad Web.
It must be 8 characters minimum.
If not set, NeoLoad Web will not start.

```yaml
    # The secret key must be at least 8 characters long
    secretKey: MySecretKeyForNeoLoadWeb
```

>**Warning:** Do not modify this key from one deployment to another, otherwise NeoLoad Web will not be able to read previously stored secrets from your database.

#### NeoLoad Web URLs

NeoLoad Web needs to know the set of hostnames it will be available under. You need to carefully configure them.

```yaml
services:
  webapp:
    host: neoload-web.mycompany.com
  api:
    host: neoload-web-api.mycompany.com
  files:
    host: neoload-web-files.mycompany.com
```

>**Note:** You must configure your DNS records. These 3 hostnames must point to the Ingress controller endpoint.
>*Example:* If the nginx ingress controller is bound to the IP 10.0.0.0, your must define the following DNS records:
>```
>neoload-web.mycompany.com.        60 IN A	10.0.0.0
>neoload-web-api.mycompany.com.    60 IN A	10.0.0.0
>neoload-web-files.mycompany.com.  60 IN A	10.0.0.0
>```
>

### Advanced configuration

Here is a list of all parameters supported by this helm chart.

Parameter | Description | Default
----- | ----------- | -------
`image.backend.repository` | The backend image repository to pull from | `neotys/neoload-web-backend`
`image.backend.pullPolicy` | The backend image pull policy | `IfNotPresent`
`image.backend.tag` | The backend image tag | See appVersion in [Chart.yaml](./Chart.yaml)
`image.frontend.repository` | The frontend image repository to pull from | `neotys/neoload-web-frontend`
`image.frontend.pullPolicy` | The frontend image pull policy | `IfNotPresent`
`image.frontend.tag` | The frontend image tag | See appVersion in [Chart.yaml](./Chart.yaml)
`imagePullSecrets` | The image pull secrets | `[]`
 |  | 
`serviceAccount.create` | Specifies whether a service account should be created | `true`
`serviceAccount.name` | The name of the service account to use | 
 |  | 
`podSecurityContext`| The pod security context | `{ fsGroup: 2000 }`
`securityContext` | The security context | `{ runAsUser: 2000 }`
 |  |
`domain` | Domain name used to configure cookies. If your frontend and api URLs are `web.mycompany.com` & `api.mycompany.com`, then the value of domain must be `.mycompany.com` |
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
`resources.backend.requests.cpu` | CPU resource request for the backend | `1`
`resources.backend.requests.memory` | Memory resource request for the backend | `2Gi`
`resources.backend.limits.cpu` | CPU resource limit for the backend | `2`
`resources.backend.limits.memory` | Memory resource limit for the backend | `3Gi`
`resources.frontend.requests.cpu` | CPU resource request for the frontend | `1`
`resources.frontend.requests.memory` | Memory resource request for the frontend | `1500Mi`
`resources.frontend.limits.cpu` | CPU resource limit for the frontend | `2`
`resources.frontend.limits.memory` | Memory resource limit for the frontend | `2Gi`
 |  | 
`neoload.configuration.externalTlsTermination` | Must be set to `true` if TLS termination is handled by a component [outside of the Helm Chart management](#external-tls-termination).  | `false`
`neoload.configuration.sendUsageStatistics` | Can be set to `false` to avoid usage data collection | `true`
 |  | 
`neoload.configuration.backend.mongo.host` | MongoDB host | 
`neoload.configuration.backend.mongo.port` | MongoDB port | `27017`
`neoload.configuration.backend.mongo.poolSize` | MongoDB pool size | `50`
`neoload.configuration.backend.java.xmx` | Java JVM Max heap size for the backend | `2000m`
`neoload.configuration.backend.misc.files.maxUploadSizeInBytes` | Max file upload size in bytes | `250000000`
`neoload.configuration.backend.misc.files.maxUploadPerWeek` | Max file upload count per week | `250`
`neoload.configuration.backend.licensingPlatformToken` | Token for enabling licensing features (such as VUHs) | 
`neoload.configuration.backend.others` | Custom backend environment variables. [Learn more.](#custom-environment-variables) |
| | 
`neoload.configuration.frontend.java.xmx` | Java JVM Max heap size for the frontend | `1200m`
`neoload.configuration.frontend.others` | Custom frontend environment variables. [Learn more.](#custom-environment-variables) |
| | 
`neoload.configuration.proxy.https` | Connection string for your https proxy. [Learn more.](#proxy)
| |
`neoload.configuration.ha.mode` | Pod discovery mecanism, can be `DNS` or `API`                                                                                         | `API`
| |
`neoload.labels.backend` | Add labels to backend resources ex: `key: value`. | `{}`
`neoload.labels.frontend` | Add labels to frontend resources ex: `key: value`. | `{}`
`neoload.annotations.backend` | Add annotations to backend resources ex: `key: value`. | `{}`
`neoload.annotations.frontend` | Add annotations to frontend resources ex: `key: value`. | `{}`
| |
`mongodb.usePassword` | Set to false if your MongoDB connection doesn't require authentication | `true`
`mongodb.mongodbUsername` | MongoDB Username | 
`mongodb.mongodbPassword` | MongoDB Password | 
 |  | 
`clusterRbac.enabled` | Specifies whether a ClusterRole and ClusterRoleBinding should be created | `true`
`nodeSelector` | Node Selector | `{}`
`tolerations` | Pod's tolerations | `[]`
`replicaCount.frontend` | Number of frontend pods in your Deployment. [Learn more.](#high-availability) | 2
`replicaCount.backend` | Number of backend pods in your Deployment. [Learn more.](#high-availability) | 2

We suggest you maintain your own *values-custom.yaml* and update it with your relevant parameters, but you can also specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
    --set ingress.tls=[] \
    neotys/nlweb
```

## Custom environment variables

`neoload.configuration.backend.others` and `neoload.configuration.frontend.others` sections of *values-custom.yaml* allow to define custom environement variables.
These environement variables will be applied either on the backend or the frontend depending on the used property.

### Example

The following example will define `ENV_VAR_1` and `ENV_VAR_2` as environement variables for the backend deployment.

```yaml
neoload:
  configuration:
    backend:
      mongo:
        host: YOUR_MONGODB_HOST_URL
        port: 27017
      others:
        ENV_VAR_1: variable1 
        ENV_VAR_2: variable2

```

## Proxy

You can define an https proxy that will be used by NeoLoad Web when using the following set of features. This set will be extended in future upgrades.

*Features taking advantage of proxies in NeoLoad Web 2.11.0*
- Licensing

The proxy can be enabled by setting the following property :

`neoload.configuration.proxy.https=https://username:password@host:port`

## TLS
If you want to secure NeoLoad Web through TLS, you should either:
 - configure [TLS at ingress level](#ingress-tls-termination)
 - handle [TLS termination on front of the Ingress controller](#external-tls-termination)

### Ingress TLS termination

To enable TLS and access NeoLoad Web via https, the parameters :

- `ingress.enabled` must be true
- `ingress.tls` must contain at least one item with the tls secret data

> **Caution**: Ingresses support multiple TLS mapped to respective hosts and paths. This feature is not supported for NeoLoad Web, i.e. exactly zero or one TLS configuration is expected.

#### Using an existing TLS secret

Simply refer to your secret in the `ingress.tls[0].secretName` parameter, and leave both `ingress.tls[0].secretCertificate` and `ingress.tls[0].secretKey` empty.

#### Creating a new TLS secret

##### Provide a certificate and a private key

Use the following documentation or use your own means to provide both a certificate and a private key.

- [Kubernetes TLS Secret generation documentation](https://kubernetes.github.io/ingress-nginx/user-guide/tls/)

##### Add these to your custom values file

Copy the content of the files into the `ingress.tls[0].secretCertificate` and `ingress.tls[0].secretKey` parameters.

##### Specify your new TLS secret name

Set a name for your new TLS secret name into the `ingress.tls[0].secretName` parameter.

### External TLS termination

>**Caution**: 
> If you choose to handle TLS on front of the Ingress controller, we recommend, for security reason, to set the 
> value of the property `neoload.configuration.externalTlsTermination` to `true`.
>
> It will enable the 'https://' protocol in NeoLoad Web URLs. 
> And it will ensure that NeoLoad Web flags the JSESSIONID cookie as `secure`.

## Usage data

NeoLoad Web collects and sends anonymized usage and navigation data to our servers in order to continuously improve our products.

You can disable this option by setting the `neoload.configuration.sendUsageStatistics` key to `false`.

### Service data

NeoLoad Web gathers and sends data related to the usage of specific features and services.

### Navigation data

NeoLoad Web uses Google Analytics cookies to track navigation data.

Any end user can prevent Google from collecting and processing their data by downloading and installing the browser plug-in available here: https://tools.google.com/dlpage/gaoptout?hl=en-GB.

*For more information about Data privacy management by Google, see the links below:*

- [Data privacy and security for Google Analytics](https://support.google.com/analytics/answer/6004245)
- [How Google uses information from sites or applications that use their services](https://www.google.com/policies/privacy/partners/)

