没有配置网桥，使用虚拟网卡（NIC，用于LAN和WAN接口。`-netdev user` 是 NAT 模式，所以宿主机访问LAN口需要端口映射。

```sh
QEMUPATH=../work_tools/qemu/bin
BINPATH=./bin/targets/armsr/armv8/openwrt-armsr-armv8-generic-initramfs-kernel.bin 

sudo $QEMUPATH/qemu-system-aarch64 \
  -M virt \
  -m 1024m \
  -kernel $BINPATH \
  -nographic \
  -cpu cortex-a53 \
  -smp 4 \
  -device virtio-net-device,netdev=lan \
  -netdev user,id=lan,hostfwd=tcp::80-:80,hostfwd=tcp::2222-:22 \
  -device virtio-net-device,netdev=wan \
  -netdev user,id=wan
```

另外openwrt虚拟机也需要配置firewall。先修改`firewall.config`方式编译固件，启动后无新增内容。

```diff
diff --git a/package/network/config/firewall/files/firewall.config b/package/network/config/firewall/files/firewall.config
index b90ac7af0a..735eaee1da 100644
--- a/package/network/config/firewall/files/firewall.config
+++ b/package/network/config/firewall/files/firewall.config
@@ -53,6 +53,23 @@ config rule
        option family           ipv4
        option target           ACCEPT
 
+# 允许从 WAN 访问 SSH（仅示例，实际需谨慎）+config rule
+    option name 'Allow-WAN-SSH'
+    option src 'wan'
+    option dest_port '22'
+    option proto 'tcp'
+    option target 'ACCEPT'
+
+# 允许从 WAN 访问 Web（仅示例，实际需谨慎）+config rule
+    option name 'Allow-WAN-WEB'
+    option src 'wan'
+    option dest_port '80'
+    option proto 'tcp'
+    option target 'ACCEPT'
+
+
 # Allow DHCPv6 replies
 # see https://github.com/openwrt/openwrt/issues/5066
 config rule
```

将上面的`firewall.config`放置`files/etc/config/firewall`文件方式编译固件启动没问题。

### 修改IP和时区

```diff
diff --git a/package/base-files/files/bin/config_generate b/package/base-files/files/bin/config_generate
index be21d0079a..b27779e86d 100755
--- a/package/base-files/files/bin/config_generate
+++ b/package/base-files/files/bin/config_generate
@@ -162,7 +162,7 @@ generate_network() {
                static)
                        local ipad
                        case "$1" in
-                               lan) ipad=${ipaddr:-"192.168.1.1"} ;;
+                               lan) ipad=${ipaddr:-"192.168.111.1"} ;;
                                *) ipad=${ipaddr:-"192.168.$((addr_offset++)).1"} ;;
                        esac
 
@@ -312,7 +312,8 @@ generate_static_system() {
                delete system.@system[0]
                add system system
                set system.@system[-1].hostname='OpenWrt'
-               set system.@system[-1].timezone='UTC'
+               set system.@system[-1].timezone='CST-8'
+               set system.@system[-1].zonename='Asia/Shanghai'
                set system.@system[-1].ttylogin='0'
                set system.@system[-1].log_size='64'
                set system.@system[-1].urandom_seed='0'
```