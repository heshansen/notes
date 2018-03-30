# redis本地安装及springboot集成

* 参考文献：[spring-boot | 整合Redis缓存数据](https://www.jianshu.com/p/a8694d97caaa);[SpringBoot #2：spring boot集成Redis缓存](https://www.jianshu.com/p/5111ceaaaacd)；[最简单的Spring Cloud配置Redis方法](https://www.hhfate.cn/t/580)

#### 第一步：本地安装配置redis

```
#Ubuntu操作指南
#安装
sudo apt-get update
sudo apt-get install redis-server
#启动redis
redis-server
#查看 redis 是否启动？
redis-cli
ping
#关闭redis
redis-cli shutdown
#在远程服务上执行命令
redis-cli -h host -p port -a password
#查看配置
CONFIG GET *
#修改配置
CONFIG SET CONFIG_SETTING_NAME NEW_CONFIG_VALUE
```

#### 第二步：springboot中集成redis

* 引入redis的依赖：创建spring boot的Maven项目,然后在pom.xml文件中引入redis的依赖。
	* 注意：spring-boot-starter-redis已经停用,只需引入下面一个依赖即可

```
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

* 添加redis的配置文件：
	* 在application.properties配置redis服务器的IP，端口号等参数
```
#redis配置
# Redis数据库索引（默认为0） 
spring.redis.database=2 
# Redis服务器地址 
spring.redis.host=localhost
# Redis服务器连接端口 
spring.redis.port=6379 
# Redis服务器连接密码（默认为空） 
spring.redis.password= 123456
#连接池最大连接数（使用负值表示没有限制）
spring.redis.pool.max-active=8 
# 连接池最大阻塞等待时间（使用负值表示没有限制） 
spring.redis.pool.max-wait=-1 
# 连接池中的最大空闲连接 
spring.redis.pool.max-idle=8 
# 连接池中的最小空闲连接 
spring.redis.pool.min-idle=0 
# 连接超时时间（毫秒） 
spring.redis.timeout=0
```
或application.yml配置
```
spring:
  redis:
    database: 0
    host: 127.0.0.1
    port: 6379
    timeout: 1000
    pool:
      max-idle: 8
      max-active: 8
      max-wait: -1
      min-idle: 0
```

* 新增RedisConfig.java配置类
	* 使用@ConfigurationProperties(prefix="spring.redis")注解，会自动将字段注入到bean中

```
import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.CachingConfigurerSupport;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.interceptor.KeyGenerator;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import redis.clients.jedis.JedisPoolConfig;

import java.lang.reflect.Method;

/**
 * <p>Title: Redis配置类</p>
 *
 * @author hess
 * @version V1.0.0
 * @date 18-3-21 下午9:15.
 */

@Configuration
@EnableCaching
public class RedisConfig extends CachingConfigurerSupport {

    private Logger logger = LoggerFactory.getLogger(this.getClass());
    /**
     * 键的生成策略
     * @return
     */
    @Bean
    public KeyGenerator wiselyKeyGenerator() {
        return new KeyGenerator() {
            @Override
            public Object generate(Object target, Method method, Object... params) {
                StringBuilder sb = new StringBuilder();
                sb.append(target.getClass().getName());
                sb.append(method.getName());
                for (Object obj : params) {
                    sb.append(obj.toString());
                }
                return sb.toString();
            }
        };
    }

    @Bean
    @ConfigurationProperties(prefix="spring.redis.pool")
    public JedisPoolConfig getRedisConfig(){
        JedisPoolConfig config = new JedisPoolConfig();
        return config;
    }

    /**
     * 配置Jedis Connect
     * 使用@ConfigurationProperties(prefix="spring.redis")注解，会自动将字段注入到bean中
     * @return
     */
    @Bean
    @ConfigurationProperties(prefix="spring.redis")
    public JedisConnectionFactory getConnectionFactory(){
        JedisConnectionFactory factory = new JedisConnectionFactory();
        JedisPoolConfig config = getRedisConfig();
        factory.setPoolConfig(config);
        logger.info("JedisConnectionFactory bean init success.");
        return factory;
    }

    /**
     * 配置CacheManager 管理cache
     * @param redisTemplate
     * @return
     */
    @Bean
    public CacheManager cacheManager(RedisTemplate redisTemplate) {
        RedisCacheManager cacheManager = new RedisCacheManager(redisTemplate);
        // 设置key-value超时时间
        cacheManager.setDefaultExpiration(60*60);
        return cacheManager;
    }

    @Bean
    public RedisTemplate<Object, Object> redisTemplate(RedisConnectionFactory connectionFactory) {
        RedisTemplate<Object, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);

        //使用Jackson2JsonRedisSerializer来序列化和反序列化redis的value值
        Jackson2JsonRedisSerializer serializer = new Jackson2JsonRedisSerializer(Object.class);

        ObjectMapper mapper = new ObjectMapper();
        mapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        mapper.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
        serializer.setObjectMapper(mapper);

        template.setValueSerializer(serializer);
        //使用StringRedisSerializer来序列化和反序列化redis的key值
        template.setKeySerializer(new StringRedisSerializer());
        template.afterPropertiesSet();
        return template;
    }
}
```

* 调用redis

```
@Autowired
private RedisTemplate<Object, Object> redisTemplate;

redisTemplate.opsForValue().set("name", "张三");

System.out.println(redisTemplate.opsForValue().get("name"));
```

