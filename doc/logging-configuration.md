# Logger configuration

> [!CAUTION]
> This modification should be guided by Tricentis support. Modifying this could lead to performance issues.

## Override the default logging configuration

You can override the default logging configuration by adding in [values-custom.yaml](../values-custom.yaml) the following section:

```yaml
loggerConfiguration: |-
  <configuration scan="true" scanPeriod="30 seconds">
    <shutdownHook />
    <appender name="STDOUT_PROD" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d [%thread] %-5level %logger{36} - %msg%n%X%n
            </pattern>
        </encoder>
    </appender>
    <appender name="ASYNC_PROD" class="ch.qos.logback.classic.AsyncAppender">
        <appender-ref ref="STDOUT_PROD" />
    </appender>
    <logger name="com.neotys" level="INFO" additivity="false">
        <appender-ref ref="ASYNC_PROD" />
    </logger>
    <logger name="com.neotys.MyLogger" level="INFO" additivity="false">
        <appender-ref ref="ASYNC_PROD" />
    </logger>
    <root level="info">
        <appender-ref ref="ASYNC_PROD" />
    </root>
  </configuration>
```

## Deploy

After adding or modifying the `loggerConfiguration` key in your `values-custom.yaml` file, you must perform an [upgrade](../README.md#upgrade) for the changes to be effective.
Then wait for the new Pods to be deployed.