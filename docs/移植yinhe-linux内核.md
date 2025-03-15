1.打包yinhe-linux源码包放入到openwrt的dl目录下。

```
git archive --format=tar --prefix=linux-5.10.197/  HEAD | xz -z > ../openwrt/dl/linux-5.10.197.tar.xz
```

2.修改openwrt的内核源码包版本和哈希值。

```
$ sha256sum dl/linux-5.10.197.tar.xz 
7b73b9f8666cbe6170f069ac7eb4350e9cfaf4f20504f34ecf698480a27fa1ec  dl/linux-5.10.197.tar.xz
```

```
$ cat include/kernel-5.10
LINUX_VERSION-5.10 = .197
LINUX_KERNEL_HASH-5.10.197 = 7b73b9f8666cbe6170f069ac7eb4350e9cfaf4f20504f34ecf698480a27fa1ec
```

3\. 创建内核配置文件，这里拷贝的默认5.15内核的配置。

```
target/linux/armsr/armv8/config-5.10
target/linux/armsr/config-5.10
target/linux/generic/config-5.10
```

4\. `config_yinhe`是适配配置

```
cp config_yinhe .config 
```
