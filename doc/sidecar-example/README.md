# How to handle traffic with custom nginx reverse proxy using side-cars

> [!WARNING] > **This feature is experimental.**
>
> It allows to deploy side-car containers on the frontend and backend Deployments.
> As it is experimental, this document may not be updated on each releases.
> It has been added starting with versions:
> - 2.15.3+ for NeoLoad Web 2024.1.x
> - 2.17.0+ for NeoLoad Web 2024.3.x and later
>
> The following content is provided as an example and must be adapted to your specific use case.

## Goals

This document demonstrates how to setup a simple (no SSL) nginx proxy as sidecar on the frontend and backend Pods.
It uses the values defined in the section [Side-car containers (experimental)](../../README.md#side-car-containers-experimental).
An [appendix](#appendix) at the end of this example is covering configuration of SSL at the nginx level.

### Updating values file

> [!NOTE]
> The following diffs are based on [values-custom.yaml file](../../values-custom.yaml).

#### Update `services` values

##### Prevent creation of Ingress for default services

Set `values.(webapp|api|files).ingress` to `null` to prevent the creation of Ingress for those services. `values.(webapp|api|files).host` can be removed as they will not be used in that scenario.

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

##### Adding custom services for side-cars

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
+ extra:
+   hosts:
+     webapp: neoload-web.mycompany.com
+     api: neoload-web-api.mycompany.com
+     files: neoload-web-files.mycompany.com
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

> [!WARNING]
> Take care to change the `server_name` property accordingly to your configuration.

```diff
-    server_name neoload-web-api.mycompany.com;
+    server_name my-real-hostname.com;
```

#### Creating ConfigMap

In the provided example the ConfigMap has been created with the following command.

```shell
kubectl create configmap nginx-conf --from-file=nginx-conf-frontend.conf --from-file=nginx-conf-backend.conf
```

## Appendix

> [!NOTE]
> The goal of this example is not to cover nginx SSL configuration. It provides a high-level guide on how to configure it and must be adapted to your needs.

### Steps

Here is a list of steps to follow to configure SSL. We are not entering the details of each one as many of them are identical to operations previously covered in this example.

- Create a ConfigMap object containing your certificates and keys
- Declare new Volumes under `extra.volumes.frontend` and `extra.volumes.backend` that mount the certificates and keys from the ConfigMap
- Add volume mounts to your frontend and backend side-cars
- Adapt the nginx configuration files configure SSL and certificate and key location

### nginx configuration

Here are some indications on the modifications required on a nginx listener to configure SSL. Example is derived from [nginx-conf-backend.conf](./nginx-conf-backend.conf).


```diff
  server {
-    listen 1443;
+    listen 1443 ssl;
    server_name neoload-web-api.mycompany.com;

+    ssl on;
+    ssl_certificate /cert/nlweb.crt;
+    ssl_certificate_key /cert/nlweb.key;
+    ssl_session_timeout 5m;
+    ssl_protocols TLSv1.2 TLSv1.3;
+    ssl_ciphers HIGH:MEDIUM:!SSLv2:!PSK:!SRP:!ADH:!AECDH;
+    ssl_prefer_server_ciphers on;
+    error_page 497  https://$host:$server_port$request_uri;

    location ~ .* {
      gzip on;
+     proxy_set_header X-Forwarded-Ssl on;

      client_max_body_size          50M;
      proxy_set_header              Connection "";
      proxy_set_header              Host $http_host;
      proxy_set_header              X-Real-IP $remote_addr;
      proxy_set_header              X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header              X-Forwarded-Proto $proxy_x_forwarded_proto;
      proxy_set_header              X-Frame-Options SAMEORIGIN;
      proxy_buffers                 256 16k;
      proxy_buffer_size             16k;
      proxy_read_timeout            600s;
      proxy_ignore_client_abort     on;
      proxy_pass                    http://localhost:1081;
      proxy_redirect                off;
    }
  }
```
