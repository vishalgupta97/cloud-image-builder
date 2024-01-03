#!/bin/sh

help="Usage: ./boot.sh [disk-file]"

ssh_port=4446
qmp_port=5556

qemu-system-x86_64 \
	--enable-kvm \
	-m 128G \
	-cpu host \
	-smp cores=48,threads=1,sockets=2 \
	-object memory-backend-ram,size=64G,id=nr0 \
	-numa node,nodeid=0,memdev=nr0,cpus=0-47 \
	-object memory-backend-ram,size=64G,id=nr1 \
	-numa node,nodeid=1,memdev=nr1,cpus=48-95 \
	-drive file=$1,index=0,format=qcow2 \
	-nographic \
	-overcommit mem-lock=off \
	-device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x6 \
	-device virtio-net-pci,netdev=hostnet0,id=net0,bus=pci.0,addr=0x3 \
	-netdev user,id=hostnet0,hostfwd=tcp::${ssh_port}-:22 \
	-qmp tcp:127.0.0.1:${qmp_port},server,nowait \
