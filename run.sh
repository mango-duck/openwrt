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
  -netdev user,id=lan \
  -device virtio-net-device,netdev=wan \
  -netdev user,id=wan,hostfwd=tcp::80-:80,hostfwd=tcp::2222-:22 
