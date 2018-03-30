# 使用Docker搭建gitlab


### 参考：

* 官网：
* 博客：[Docker入门与实战系列：进阶](https://my.oschina.net/gudaoxuri/blog/527152)

### 实践

* 获取redis镜像并运行（可以不用）

```
docker pull redis
docker run --name gitlab-cache -d redis
```

* 获取mysql镜像并运行（可以不用）

```
sudo mkdir -p /opt/gitlab/db/
docker pull mysql:5.7
docker run --name gitlab-db -e MYSQL_ROOT_PASSWORD=123456 -d -p 3307:3306 -v /opt/gitlab/db:/var/lib/mysql mysql:5.7  
```

* 创建相应数据库及权限（可以不用）

```
docker exec -it gitlab-db /bin/bash
mysql -uroot -p123456
CREATE USER 'gitlab'@'%.%.%.%' IDENTIFIED BY 'password';
CREATE DATABASE IF NOT EXISTS `gitlabhq_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;
GRANT ALL PRIVILEGES ON `gitlabhq_production`.* TO 'gitlab'@'%.%.%.%';
exit
exit
```

* 获取gitlab镜像并运行

```
docker pull gitlab/gitlab-ce
sudo mkdir -p /srv/gitlab/data /srv/gitlab/logs /srv/gitlab/config
sudo docker run --detach \
    --hostname gitlab.example.com \
    --publish 8929:80 --publish 2289:22 \
    --name gitlab \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce
```

* 登录gitlab

```
访问：http://192.168.31.203:8929
首次访问用户名/密码：root/5iveL!fe

```

* 第一阶段完成，本地基本可运行。

* 邮箱设置

```
# 通过SMTP来发送邮件
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.qq.com"
gitlab_rails['smtp_port'] = 25
# 邮箱账号
gitlab_rails['smtp_user_name'] = "heshansen@qq.com"
# 邮箱密码
gitlab_rails['smtp_password'] = "wemWEM333"
# 邮箱域：这里填写qq.com就好
gitlab_rails['smtp_domain'] = "qq.com"
gitlab_rails['smtp_authentication'] = :login
gitlab_rails['smtp_enable_starttls_auto'] = true
##修改gitlab配置的发信人
# 第一行配置一定要和qq邮箱的账户名一样否则可能发送失败
gitlab_rails['gitlab_email_from'] = "heshansen@qq.com"
user["git_user_email"] = "heshansen@qq.com"
```

* 本地依然无法发送邮件