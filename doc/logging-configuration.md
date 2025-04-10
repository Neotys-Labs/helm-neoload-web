# Logging configuration

> [!CAUTION]
> Do not modify thing unless you know what you are doing. This is a sensitive configuration, it may cause issues with the system.

## Override the default logging configuration

You can override the default logging configuration by adding in [values-custom.yaml](..%2Fvalues-custom.yaml) the following section:

```yaml
### Logging configuration
logback: |-
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

You can then make the modifications you want.  
Afterward, you will just need to perform an [upgrade](../README.md#upgrade) to apply the changes.  
The changes will take effect on both the backend and the frontend in less than five minutes.