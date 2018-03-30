# spring cloud 学习笔记

### spring cloud

* 项目官网：[spring-cloud-project](http://projects.spring.io/spring-cloud/)
* github地址：[spring-cloud-github](https://github.com/spring-cloud)

#####　版本说明

* Finchley builds and works with Spring Boot 2.0.x, and is not expected to work with Spring Boot 1.5.x.
* The Dalston and Edgware release trains build on Spring Boot 1.5.x, and are not expected to work with Spring Boot 2.0.x.
* The Camden release train builds on Spring Boot 1.4.x, but is also tested with 1.5.x.
* NOTE: The Brixton and Angel release trains were marked end-of-life (EOL) in July 2017.

### Spring FeignClient

* 参考：[Spring FeignClient 入门](https://www.jianshu.com/p/f908171b5025)

* 简介：Feign是一种声明式、模板化的HTTP客户端。在Spring Cloud中使用Feign, 我们可以做到使用HTTP请求远程服务时能与调用本地方法一样的编码体验。

* 使用，微服务中新增一个接口，并加上@FeignClient注解即可，如：

```
@FeignClient(name = "github-client", url = "https://api.github.com", configuration = GitHubExampleConfig.class)
public interface GitHubClient {
    @RequestMapping(value = "/search/repositories", method = RequestMethod.GET)
    String searchRepo(@RequestParam("q") String queryStr);
}
# 其中“/search/repositories”为调用其他微服务（github-client）的接口
```

### Spring Cloud Sleuth 实现全链路监控

##### 参考

* 官网：[Quick Start](https://cloud.spring.io/spring-cloud-sleuth/)
* 博客参考1:[使用Spring Cloud Sleuth实现链路监控](http://www.spring4all.com/article/156)
* 博客参考2：[利用Zipkin对Spring Cloud应用进行服务追踪分析](https://yq.aliyun.com/articles/60165)

##### 关键点剖析

* 痛点：如果你的微服务数量逐渐增大，服务间的依赖关系越来越复杂，错综复杂的网状结构使得我们不容易定位到某一个执行缓慢的接口；怎么分析它们之间的调用关系及相互的影响？


