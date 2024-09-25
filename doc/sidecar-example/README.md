# How to inject side-cars?

> [!WARNING] 
> **This feature is experimental.**
> 
> It allows to deploy side-car containers on the frontend and backend Deployments.
> As it is experimental, this document may not be updated on each releases.
> It has been added starting with version 2.x.y //TODO define version.
>
> The following content is provided as a basis. 
> It needs to be adapted by yourself to your specific use case.

## Goals

This document demonstrates how to setup a simple (no SSL) nginx proxy as sidecar on the frontend and backend Pods.
It uses the values defined in the section [Side-car containers (experimental)](../../README.md#side-car-containers-experimental).

### Updating values file

> [!NOTE]
> The following diffs are based on [values-custom.yaml file](../../values-custom.yaml).

#### Update `services` values

##### Prevent creation of Ingress for default services

By defining `values.(webapp|api|files).ingress` to `null`, this will prevent the creation of Ingress for those services.

```diff
### Services host configuration
services:
  webapp:
-    host: neoload-web.mycompany.com
+    ingress: null
  api:
-    host: neoload-web-api.mycompany.com
+    ingress: null
  files:
-    host: neoload-web-files.mycompany.com
+    ingress: null
```

##### Adding new services for side-cars

Now let's define services for our side-cars. This will allow to create Services & Ingresses.

> [!CAUTION]
> Label of your services **must** match the name of ports from your side-car containers.
> In the following example, it means that `webapp-proxy`, `api-proxy` and `files-proxy` are names of your side-car containers.

```diff
### Services host configuration
services:
  webapp:
    ingress: null
  api:
    ingress: null
  files:
    ingress: null
+  webapp-proxy:
+    component: frontend
+    host: neoload-web.mycompany.com
+    type: ClusterIP
+    port: 80
+    ingress:
+      paths: ["/"]
+  api-proxy:
+    component: backend
+    host: neoload-web-api.mycompany.com
+    type: ClusterIP
+    port: 80
+    ingress:
+      paths: ["/"]
+  files-proxy:
+    component: backend
+    host: neoload-web-files.mycompany.com
+    type: ClusterIP
+    port: 80
+    ingress:
+      paths: ["/"]
```

##### Overriding hosts configuration

Add the following section in the values file.

```diff
+ hostOverrides:
+   webapp: neoload-web.mycompany.com
+   api: neoload-web-api.mycompany.com
+   files: neoload-web-files.mycompany.com
```

#### Defining side-car containers

Use the new values `extra.containers.backend` and `extra.containers.frontend` provide definition of your side-cars.
These values expect an array of valid [Containers](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#container-v1-core).

See [`values-custom-side-car.yaml`](./values-custom-side-car.yaml) for a full example.

> [!CAUTION]
> As seen in a [previous section](#adding-new-services-for-side-cars) the port names in your containers must match the name of services defined previously.

#### Defining additional volumes

You may notice that the containers in the previous example are referencing volumes.
You can define additional volumes through the `extra.volumes.backend` and `extra.volumes.frontend` values.

See [`values-custom-side-car.yaml`](./values-custom-side-car.yaml) for a full example.

> [!NOTE]
> Volumes `proxy-frontend-conf-volume` and `proxy-backend-conf-volume` are referencing a ConfigMap. See the [nginx configuration](#nginx-configuration) section for more details.

### nginx configuration

> [!NOTE]
> This section doesn't relate directly to the chart configuration. This is provided as a basis that you must adapt to your specific case!

Configuring a reverse proxy for NeoLoad Web requires specific configuration. Here are simple (without SSL) nginx configuration examples for frontend and backend.

- [frontend configuration](./nginx-conf-frontend.conf)
- [backend configuration](./nginx-conf-backend.conf)

#### Creating ConfigMap

In the provided example the ConfigMap has been created with the following command.

```shell
kubectl create configmap nginx-conf --from-file=nginx-conf-frontend.conf --from-file=nginx-conf-backend.conf
```
