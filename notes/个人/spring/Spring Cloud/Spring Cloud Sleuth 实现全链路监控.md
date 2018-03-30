# Spring Cloud Sleuth + zipkin 实现全链路监控

### 前言

* 痛点：如果你的微服务数量逐渐增大，服务间的依赖关系越来越复杂，错综复杂的网状结构使得我们不容易定位到某一个执行缓慢的接口；怎么分析它们之间的调用关系及相互的影响？
* 问题：一个请求进来，整个调用链是什么样的，各个服务的调用时间，错误出现在哪个服务、哪台机器上等等问题。如果没有贯穿前后的调用链，很难定位问题。

Sleuth能带来什么？

* **耗时分析**: 通过Sleuth可以很方便的了解到每个采样请求的耗时，从而分析出哪些服务调用比较耗时;
* **可视化错误**: 对于程序未捕捉的异常，可以通过集成Zipkin服务界面上看到;
* **链路优化**: 对于调用比较频繁的服务，可以针对这些服务实施一些优化措施。

### Sleuth原理

* sleuth 实现原理，简单说就是通过拦截器(Filter)处理http请求头信息，把需要日志打印的信息放入slf4j.MDC，logback获取相应信息输出到文件或控制台等(不建议直接从logback通过网络导出lagstash、kafka等)。

### 几个概念

* Trace：一组代表一次用户请求所包含的spans，其中根span只有一个。
* Span： 一组代表一次HTTP/RPC请求所包含的annotations。
* annotation：包括一个值，时间戳，主机名(留痕迹)。

* cs：客户端发起请求，标志Span的开始
* sr：服务端接收到请求，并开始处理内部事务，其中sr - cs则为网络延迟和时钟抖动
* ss：服务端处理完请求，返回响应内容，其中ss - sr则为服务端处理请求耗时
* cr：客户端接收到服务端响应内容，标志着Span的结束，其中cr - ss则为网络延迟和时钟抖动

### Demo

##### zipkin-service

* pom.xml

```
	<!--zipkin 核心依赖 start-->
	<dependency>
		<groupId>io.zipkin.java</groupId>
		<artifactId>zipkin-server</artifactId>
	</dependency>
	<dependency>
		<groupId>io.zipkin.java</groupId>
		<artifactId>zipkin-autoconfigure-ui</artifactId>
	</dependency>
	<dependency>
		<groupId>io.zipkin.java</groupId>
		<artifactId>zipkin-storage-mysql</artifactId>
		<version>1.28.0</version>
	</dependency>
	<!--zipkin 核心依赖 end-->

	<!--数据库链接-->
	<dependency>
		<groupId>mysql</groupId>
		<artifactId>mysql-connector-java</artifactId>
	</dependency>
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-jdbc</artifactId>
	</dependency>
```

* zipkin-autoconfigure-ui提供了默认了UI页面，zipkin-storage-mysql选择将链路调用信息存储在mysql中，更多的选择可以有elasticsearch，cassandra等。

* appliaction.yml

```
spring:
  application:
    name: zipkin-service
  profiles:
    active: development
  datasource:
    url: jdbc:mysql://localhost:3306/topbaby_zipkin
    username: root
    password: 333
    driver-class-name: com.mysql.jdbc.Driver
    schema: classpath:mysql.sql
    continue-on-error: false
zipkin:
   storage:
      type: mysql
server:
  port: 8085

---
spring:
  profiles: development

```

* Spring JDBC有一个初始化DataSource特性，Spring Boot默认启用该特性，并从标准的位置schema.sql和data.sql（位于classpath根目录）加载SQL，也可自定义，如：classpath:mysql.sql；pring.datasource.continue-on-error=true禁用快速失败特性，默认是false，一旦应用程序成熟并被部署了很多次，那该设置就很有用;

* msyql.sql

```
create table if not exists zipkin_spans (
  `trace_id_high` bigint not null default 0 comment 'If non zero, this means the trace uses 128 bit traceIds instead of 64 bit',
  `trace_id` bigint not null,
  `id` bigint not null,
  `name` varchar(255) not null,
  `parent_id` bigint,
  `debug` bit(1),
  `start_ts` bigint comment 'Span.timestamp(): epoch micros used for endTs query and to implement TTL',
  `duration` bigint comment 'Span.duration(): micros used for minDuration and maxDuration query'
) engine=innodb row_format=compressed character set=utf8 collate utf8_general_ci;

alter table zipkin_spans add unique key(`trace_id_high`, `trace_id`, `id`) comment 'ignore insert on duplicate';
alter table zipkin_spans add index(`trace_id_high`, `trace_id`, `id`) comment 'for joining with zipkin_annotations';
alter table zipkin_spans add index(`trace_id_high`, `trace_id`) comment 'for getTracesByIds';
alter table zipkin_spans add index(`name`) comment 'for getTraces and getSpanNames';
alter table zipkin_spans add index(`start_ts`) comment 'for getTraces ordering and range';

create table if not exists zipkin_annotations (
  `trace_id_high` bigint not null default 0 comment 'If non zero, this means the trace uses 128 bit traceIds instead of 64 bit',
  `trace_id` bigint not null comment 'coincides with zipkin_spans.trace_id',
  `span_id` bigint not null comment 'coincides with zipkin_spans.id',
  `a_key` varchar(255) not null comment 'BinaryAnnotation.key or Annotation.value if type == -1',
  `a_value` blob comment 'BinaryAnnotation.value(), which must be smaller than 64KB',
  `a_type` int not null comment 'BinaryAnnotation.type() or -1 if Annotation',
  `a_timestamp` bigint comment 'Used to implement TTL; Annotation.timestamp or zipkin_spans.timestamp',
  `endpoint_ipv4` int comment 'Null when Binary/Annotation.endpoint is null',
  `endpoint_ipv6` binary(16) comment 'Null when Binary/Annotation.endpoint is null, or no IPv6 address',
  `endpoint_port` smallint comment 'Null when Binary/Annotation.endpoint is null',
  `endpoint_service_name` varchar(255) comment 'Null when Binary/Annotation.endpoint is null'
) engine=innodb row_format=compressed character set=utf8 collate utf8_general_ci;

alter table zipkin_annotations add unique key(`trace_id_high`, `trace_id`, `span_id`, `a_key`, `a_timestamp`) comment 'Ignore insert on duplicate';
alter table zipkin_annotations add index(`trace_id_high`, `trace_id`, `span_id`) comment 'for joining with zipkin_spans';
alter table zipkin_annotations add index(`trace_id_high`, `trace_id`) comment 'for getTraces/ByIds';
alter table zipkin_annotations add index(`endpoint_service_name`) comment 'for getTraces and getServiceNames';
alter table zipkin_annotations add index(`a_type`) comment 'for getTraces';
alter table zipkin_annotations add index(`a_key`) comment 'for getTraces';
alter table zipkin_annotations add index(`trace_id`, `span_id`, `a_key`) comment 'for dependencies job';

create table if not exists zipkin_dependencies (
  `day` date not null,
  `parent` varchar(255) not null,
  `child` varchar(255) not null,
  `call_count` bigint,
  `error_count` bigint
) engine=innodb row_format=compressed character set=utf8 collate utf8_general_ci;

alter table zipkin_dependencies add unique key(`day`, `parent`, `child`);
```

* 初始化数据库，可手动导入，也可在springboot启动类里自动导入。

* 启动类ZipkinServiceApplication

```
@SpringBootApplication
@EnableZipkinServer
public class ZipkinServiceApplication {

  /** 初始化数据库（可手动）*/
	@Bean
	public MySQLStorage mySQLStorage(DataSource datasource) {
		return MySQLStorage.builder().datasource(datasource).executor(Runnable::run).build();
	}

	public static void main(String[] args) {
		SpringApplication.run(ZipkinServiceApplication.class, args);
	}
}
```

* 启动zipkin-service,本地页面：http://localhost:8085/zipkin/，此时没有任何记录。

##### 

### 参考

* **官网：[Quick Start](https://cloud.spring.io/spring-cloud-sleuth/)**
* **官网：[Github](https://github.com/spring-cloud/spring-cloud-sleuth)**
* 博客参考1:[使用Spring Cloud Sleuth实现链路监控](http://www.spring4all.com/article/156)
* 博客参考2：[利用Zipkin对Spring Cloud应用进行服务追踪分析](https://yq.aliyun.com/articles/60165)
* 教程1：[Spring Cloud入门教程(七)：分布式链路跟踪(Sleuth)](https://www.jianshu.com/p/c3d191663279)
