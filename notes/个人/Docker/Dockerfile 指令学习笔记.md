# Dockerfile 指令学习笔记

### 参考
* 官网：[Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)
* 中文版参考：[Dockerfile最佳实践](http://tuxknight-notes.readthedocs.io/en/latest/docker/dockerfile_best_practices_take.html)

### 总结
* COPY 和 ADD 指令选择原则：所有的文件复制均使用 COPY 指令，仅在需要自动解压缩的场合使用 ADD。
* 容器模型是进程而不是机器，不需要开机初始化。
* VOLUME 指令应当暴露出数据库的存储位置，配置文件的存储以及容器中创建的文件或目录。由于容器结束后并不保存任何更改，你应该把所有数据通过 VOLUME 保存到host中。