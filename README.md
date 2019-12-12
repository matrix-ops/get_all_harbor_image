# 获取指定Harbor私有Registry的所有镜像列表
用法：
更改Harbor的账号密码以及地址，然后执行：
```shell
bash get_all_harbor_image.sh
```
注意，获取完成之后，如果需要pull指定的镜像，并且Harbor启用了https，您需要在客户端配置https访问harbor。
