# Configure NeoLoad Web to use TLS when connecting to MongoDB

> This document will not cover the MongoDB server configuration. MongoDB is a well documented product and you will find everything that you need to know on its [own documentation](https://www.mongodb.com/docs/v7.0/reference/program/mongod/#tls-options).

## Configure NeoLoad Web to use TLS

First thing to do is to configure the MongoDB host in NeoLoad Web configuration as described [here](../README.md#host-and-port).

You to need to append the `ssl=true` to the host value.

>**Example:** For MongoDB requiring SSL connection, the `host` value must look like: `mongodb://mongo.mycompany.com:27017/admin?ssl=true`

However, depending on your server configuration and the kind of certificates you're using it could not be enough.

Let's start by looking at the [server certificate](#server-certificate), then if you're server is requesting TLS client authentication take also a look at [client certificate](#client-certificate).

## Server certificate

### Trusted server certificate

No additional configuration is required if your server certificate is signed by a known Certificate Authority.

### Untrusted (self-signed) server certificate

More configuraton is required if you're using a self-signed (or delivered by a non trusted Certifacte Authority) server certificate.
In this case you can find an error message like the following:

```log
2022-08-16 14:53:57,692 [vert.x-eventloop-thread-0] INFO  org.mongodb.driver.cluster - No server chosen by com.mongodb.reactivestreams.client.internal.ClientSessionHelper$$Lambda$422/1942374648@33694c87 from cluster description ClusterDescription{type=UNKNOWN, connectionMode=SINGLE, serverDescriptions=[ServerDescription{address=mongo.mycompany.com:27017, type=UNKNOWN, state=CONNECTING, exception={com.mongodb.MongoSocketWriteException: Exception sending message}, caused by {javax.net.ssl.SSLHandshakeException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target}, caused by {sun.security.validator.ValidatorException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target}, caused by {sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target}}]}. Waiting for 30000 ms before timing out
```

In this scenario, by default, the certificate will not be trusted by Java and you will need to do more configuration.

- Creating a Java truststore
- Attach a volume containing the truststore to the backend pod
- Change backend pod to direct him to use the truststore

#### Creating a Java truststore

Create a folder java-stores.

Here we are using the NeoLoad image to be sure to use the same JDK version than runtime.

```shell
mkdir java-stores
cp </path/to/server.cert.pem> ./java-stores/
docker run -it -v $PWD/java-stores:/server/stores:rw --user root --entrypoint sh neotys/neoload-web-frontend:latest
```

In the container shell run

```shell
keytool.exe -import -alias myAlias -file <server.cert.pem> -keystore truststore.jks -storepass changeit -noprompt -trustcacerts
```

Exit the container.

The java-stores folder should contain a file `truststore.jks`. We will use it in the following steps.

#### Attach a volume containing the truststore to the backend pod



#### Change backend pod to direct him to use the truststore

## Client certificate
