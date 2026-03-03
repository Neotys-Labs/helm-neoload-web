# Advanced configuration

## Values reference

Here is a list of all values supported by this helm chart.

Parameter | Description | Default
----- | ----------- | -------
`image.backend.repository` | The backend image repository to pull from | `neotys/neoload-web-backend`
`image.backend.pullPolicy` | The backend image pull policy | `IfNotPresent`
`image.backend.tag` | The backend image tag | See appVersion in [Chart.yaml](./Chart.yaml)
`image.frontend.repository` | The frontend image repository to pull from | `neotys/neoload-web-frontend`
`image.frontend.pullPolicy` | The frontend image pull policy | `IfNotPresent`
`image.frontend.tag` | The frontend image tag | See appVersion in [Chart.yaml](./Chart.yaml)
`image.backendUtilities.repository` | The backend-utilities image repository to pull from | `neotys/neoload-web-backend-utilities`
`image.backendUtilities.pullPolicy` | The backend-utilities image pull policy | `IfNotPresent`
`image.backendUtilities.tag` | The backend-utilities image tag | See appVersion in [Chart.yaml](./Chart.yaml)
`imagePullSecrets` | The image pull secrets | `[]`
 |  | 
`serviceAccount.create` | Specifies whether a service account should be created | `true`
`serviceAccount.name` | The name of the service account to use | 
 |  | 
`podSecurityContext`| The pod security context | `{ fsGroup: 2000 }`
`securityContext` | The security context | `{ runAsUser: 2000 }`
 |  |
`domain` | **(Required)** Domain name used to configure cookies and compute the base CORS allowed origin pattern. If your frontend and api URLs are `web.mycompany.com` & `api.mycompany.com`, then the value of domain must be `.mycompany.com` |
|  |
`services.webapp.host` | The hostname for the webapp/front deployment | 
`services.webapp.type` | The service type for the webapp/front deployment | `ClusterIP`
`services.webapp.port` | The service port for the webapp/front deployment | `80`
`services.webapp.ingress.paths` | The path mapping for the webapp/front ingress. If value is `null`, ingress will not be created for this service. | `[""]`
`services.api.host` | The hostname for the api deployment | 
`services.api.type` | The service type for the api deployment | `ClusterIP`
`services.api.port` | The service port for the api deployment | `80`
`services.api.ingress.paths` | The path mapping for the api ingress. If value is `null`, ingress will not be created for this service. | `[""]`
`services.api-v4.host` | The hostname for the API v4 endpoints. If unset, falls back to `services.api.host`. |
`services.api-v4.type` | The service type for the API v4 service | `ClusterIP`
`services.api-v4.port` | The service port for the API v4 service | `80`
`services.api-v4.ingress.paths` | The path mapping for the API v4 ingress. | `["/v4"]`
`services.files.host` | The hostname for the files deployment | 
`services.files.type` | The service type for the files deployment | `ClusterIP`
`services.files.port` | The service port for the files deployment | `80`
`services.files.ingress.paths` | The path mapping for the files ingress. If value is `null`, ingress will not be created for this service. | `[""]`
 |  | 
`ingress.enabled` | Enable ingresses | `true`
`ingress.class` | Specifies which ingress controller class should listen to this ingress | `nginx`
`ingress.annotations` | Annotations for configuring the ingress | 
`ingress.tls[0].secretName` | The name of your TLS secret | 
`ingress.tls[0].secretCertificate` | The content of your imported certificate | `{}`
`ingress.tls[0].secretKey` | The content of your imported private key | 
 |  | 
`resources.backend.requests.cpu` | CPU resource request for the backend | `1`
`resources.backend.requests.memory` | Memory resource request for the backend | `2500Mi`
`resources.backend.limits.cpu` | CPU resource limit for the backend | `2`
`resources.backend.limits.memory` | Memory resource limit for the backend | `3Gi`
`resources.frontend.requests.cpu` | CPU resource request for the frontend | `50m`
`resources.frontend.requests.memory` | Memory resource request for the frontend | `250Mi`
`resources.frontend.limits.memory` | Memory resource limit for the frontend | `250Mi`
`resources.backendUtilities.requests.cpu` | CPU resource request for the backend-utilities | `100m`
`resources.backendUtilities.requests.memory` | Memory resource request for the backend-utilities | `500Mi`
`resources.backendUtilities.limits.memory` | Memory resource limit for the backend-utilities | `1Gi`
 |  | 
`neoload.configuration.externalTlsTermination` | Must be set to `true` if TLS termination is handled by a component [outside of the Helm Chart management](#external-tls-termination).  | `false`
`neoload.configuration.sendUsageStatistics` | Can be set to `false` to avoid usage data collection | `true`
`neoload.configuration.secretKey` | **(Required)** Secret key used to encrypt and decrypt passwords stored by NeoLoad Web. Must be at least 8 characters. See [NeoLoad Web secret key](../README.md#neoload-web-secret-key) for details | 
`neoload.configuration.secretKeyExistingSecret` | Name of an existing Secret containing the secret key. Must have the key `nlwSecretKey`. Takes precedence over `neoload.configuration.secretKey`. | 
 |  | 
`neoload.configuration.backend.mongo.host` | MongoDB host, should be omitted if using `mongodb.existingSecret`. See [MongoDB Authentication](../README.md#authentication) for details |
`neoload.configuration.backend.mongo.port` | MongoDB port | `27017`
`neoload.configuration.backend.mongo.poolSize` | MongoDB pool size | `50`
`neoload.configuration.backend.java.xmx` | Java JVM Max heap size for the backend | `2000m`
`neoload.configuration.backend.misc.maxFormAttributeSize` | Maximum size in bytes for HTTP form attributes (e.g., for SSO form parameters) | `32768`
`neoload.configuration.backend.misc.files.maxUploadSizeInBytes` | Max file upload size in bytes | `250000000`
`neoload.configuration.backend.misc.files.maxUploadPerWeek` | Max file upload count per week | `250`
`neoload.configuration.backend.licensingPlatformToken` | Token for enabling licensing features (such as VUHs) | 
`neoload.configuration.backend.licensingPlatformTokenExistingSecret` | Name of an existing Secret containing the licensing platform token. Must have the key `licensingPlatformToken`. Takes precedence over `licensingPlatformToken`. | 
`neoload.configuration.backend.livenessProbe.initDelaySeconds` | Backend Pods liveness probe initial delay in seconds | 60
`neoload.configuration.backend.readinessProbe.initDelaySeconds` | Backend Pods readiness probe initial delay in seconds | 60
`neoload.configuration.backend.others` | Custom backend environment variables. [Learn more.](#custom-environment-variables) |
`neoload.configuration.backend.cors.additionalAllowedOriginPattern` | Additional CORS origin regex appended to base `scheme + ".*" + domain`. Example: `https://.*.okta.com` | 
| | 
`neoload.configuration.frontend.livenessProbe.initDelaySeconds` | Frontend Pods liveness probe initial delay in seconds | 60
`neoload.configuration.frontend.readinessProbe.initDelaySeconds` | Frontend Pods readiness probe initial delay in seconds | 20
`neoload.configuration.frontend.others` | Custom frontend environment variables. [Learn more.](#custom-environment-variables) |
| | 
`neoload.configuration.proxy.https` | Connection string for your https proxy. Configuring proxy should be done through the application, using this value is only here as a workaround. 
| |
`neoload.configuration.ha.mode` | Pod discovery mecanism, can be `DNS` or `API`                                                                                         | `API`
| |
`neoload.labels.backend` | Add labels to backend resources ex: `key: value`. | `{}`
`neoload.labels.frontend` | Add labels to frontend resources ex: `key: value`. | `{}`
`neoload.labels.backendUtilities` | Add labels to backend-utilities resources ex: `key: value`. | `{}`
`neoload.annotations.backend` | Add annotations to backend resources. It will be applied to both `Deployment` and `Pod`; if you want a specific annotation applied to `Pod` or `Deployment`, please use `neoload.annotations.pod.backend` or `neoload.annotations.deployment.backend`. | `{}`
`neoload.annotations.frontend` | Add annotations to frontend resources. It will be applied to both `Deployment` and `Pod`; if you want a specific annotation applied to `Pod` or `Deployment`, please use `neoload.annotations.pod.frontend` or `neoload.annotations.deployment.frontend`. | `{}`
`neoload.annotations.backendUtilities` | Add annotations to backend-utilities resources. It will be applied to both `Deployment` and `Pod`; if you want a specific annotation applied to `Pod` or `Deployment`, please use `neoload.annotations.pod.backendUtilities` or `neoload.annotations.deployment.backendUtilities`. | `{}`
`neoload.annotations.pod.backend` | Add annotations to backend pods ex: `key: value`. | `{}`
`neoload.annotations.pod.backendUtilities` | Add annotations to backend-utilities pods ex: `key: value`. | `{}`
`neoload.annotations.pod.frontend` | Add annotations to frontend pods ex: `key: value`. | `{}`
`neoload.annotations.deployment.backend` | Add annotations to backend deployment ex: `key: value`. | `{}`
`neoload.annotations.deployment.backendUtilities` | Add annotations to backend-utilities deployment ex: `key: value`. | `{}`
`neoload.annotations.deployment.frontend` | Add annotations to frontend deployment ex: `key: value`. | `{}`
| |
`mongodb.usePassword` | Set to false if your MongoDB connection doesn't require authentication | `true`
`mongodb.mongodbUsername` | MongoDB Username | 
`mongodb.mongodbPassword` | MongoDB Password | 
`mongodb.existingSecret` | Name of an existing Secret containing MongoDB credentials. See [MongoDB Authentication](../README.md#authentication) for details | 
 |  | 
`clusterRbac.enabled` | Specifies whether a ClusterRole and ClusterRoleBinding should be created. Only applies when `neoload.configuration.ha.mode` is `API`. | `true`
`nodeSelector` | Node Selector | `{}`
`tolerations` | Pod's tolerations | `[]`
`replicaCount.frontend` | Number of frontend pods in your Deployment. [Learn more.](#high-availability) | 2
`replicaCount.backend` | Number of backend pods in your Deployment. [Learn more.](#high-availability) | 2
`replicaCount.backendUtilities` | Number of backend-utilities pods in your Deployment. | 1
`loggerConfiguration` | Logger configuration. [Learn more.](./doc/logging-configuration.md) | [Default logger configuration as defined here](./values.yaml)
`extra.volumes.backend` | Allows specifying a list of valid [Volumes](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#volume-v1-core). These will be added to the PodSpec of the backend Deployment. |
`extra.volumeMounts.backend` | Add custom volume mounts to the NeoLoad Web backend Container.  | 
 |  | 
`migration.skipBreakingChangesChecks` | Skip breaking changes validation checks during helm template rendering. Use with caution, only if you understand the implications. | `false`

## CORS allowed origins

[CORS (Cross-Origin Resource Sharing)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) is a browser security mechanism that controls which external domains can make requests to your NeoLoad Web API.

**When do you need to configure CORS?**

- **SSO/IdP integration** (most common): When using external Identity Providers like Okta, Keycloak, or Azure AD for Single Sign-On, these services need permission to interact with NeoLoad Web.
- **External web applications**: When another web application hosted on a different domain needs to consume the NeoLoad Web API.

By default, NeoLoad Web allows requests from any subdomain matching your configured `domain`. If your IdP or external application is hosted outside this domain, you must explicitly allow it.

### Configuration

- The backend computes a base CORS pattern from your configured scheme and domain: `https://.*<domain>`.
  - Example: with `domain: .mycompany.com`, the base is `https://.*.mycompany.com`.
- You can append one extra allowed origin by setting `neoload.configuration.backend.cors.additionalAllowedOriginPattern`.
- At runtime, the env `CORS_ALLOWED_ORIGIN_PATTERN` becomes either:
  - `https://.*.<domain>` (default), or
  - `https://.*.<domain>,<your-additional-pattern>` when configured.

Example values override (Okta wildcard):

```yaml
neoload:
  configuration:
    backend:
      cors:
        additionalAllowedOriginPattern: "https://.*.okta.com"
```

Other examples:
- Exact Okta tenant: `"https://my-tenant.okta.com"`
- Keycloak single host: `"https://keycloak.example.com"`
- Azure AD (example): `"https://login.microsoftonline.com"`

## Side-car containers

> [!CAUTION]
> When using `services.<name>.*` values the `<name>` must map the name of a port declared in containers under `extra.containers.backend` or `extra.containers.frontend`.

For a detailed example on how to use this feature take a look at [this example](./doc/sidecar-example/README.md).


Parameter | Description | Default
----- | ----------- | -------
`extra.hosts.webapp` | Overrides the app configuration if the hostname used to access NeoLoad Web Frontend is different than the value of `services.webapp.host`|
`extra.hosts.api` | Overrides the app configuration if the hostname used to access NeoLoad Web API is different than the value of `services.api.host`|
`extra.hosts.api-v4` | Overrides the app configuration for API v4 host. Takes precedence over `services.api-v4.host` and the api fallback. |
`extra.hosts.files` | Overrides the app configuration if the hostname used to access NeoLoad Web Files API is different than the value of `services.files.host`|
`extra.containers.backend` | Allows specifying a list of valid [Containers](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#container-v1-core). These will be added to the list of Containers of the backend Deployment. |
`extra.containers.frontend` | Allows specifying a list of valid [Containers](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#container-v1-core). These will be added to the list of Containers of the frontend Deployment. |
`extra.volumes.frontend` | Allows specifying a list of valid [Volumes](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#volume-v1-core). These will be added to the PodSpec of the frontend Deployment. |
`services.<name>.component` | The Deployment to which this service is attached can be either `frontend` or `backend`. | 
`services.<name>.host` | The hostname for the `<name>` service | 
`services.<name>.type` | The type for the `<name>` service | `ClusterIP`
`services.<name>.port` | The port for the `<name>` service | `80`
`services.<name>.ingress.paths` | The path mapping for the service ingress. If value is `null`, ingress will not be created for this service. | `[""]`

## Custom environment variables

`neoload.configuration.backend.others`, `neoload.configuration.backendUtilities.others` and `neoload.configuration.frontend.others` values allow to define custom environement variables.
These environement variables will be applied on the corresponding Depolyment.

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

## Logger configuration

See the dedicated [page](./logging-configuration.md).