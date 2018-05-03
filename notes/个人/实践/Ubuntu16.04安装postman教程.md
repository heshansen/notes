# Ubuntu16.04安装postman教程

### 参考地址

* [How to Install the Postman Native App in Ubuntu 16.04](https://blog.bluematador.com/posts/postman-how-to-install-on-ubuntu-1604/?utm_source=hootsuite&utm_medium=twitter&utm_campaign=)

* [ ubuntu安装postman](https://blog.csdn.net/qianmosolo/article/details/79353632)

### 实践（参考第二篇文章）

* postman下载地址：https://www.getpostman.com/apps

* 解压缩：

```
 sudo tar -xzf Postman-linux-x64-5.5.3.tar.gz
 # 启动postman
 ./Postman/Postman
```

* 创建启动图标

```
# 建立软链接(前面地址为安装目录，后面软链接地址)
 sudo ln -s /home/hess/software/Postman/Postman /usr/bin/postman
# 创建启动项文件
cd /urs/share/applications/
sudo touch postman.desktop
sudo vim  postman.desktop
# 写入：
 [Desktop Entry]

      Encoding=UTF-8

      Name=Postman

      Exec=/usr/bin/postman

      Icon=/home/hess/software/Postman/Postman/app/assets/icon.png

      Terminal=false

      Type=Application

      Categories=Development;
# 在dash里就可以搜索到Postman
```