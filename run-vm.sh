
#kernel=base-5.14.16.bzImage
#kernel=base-6.6.16.bzImage
#kernel=../kcombiner/src/kernel/linux-5.14.16/arch/x86/boot/bzImage
kernel=../feedback-sync/linux/arch/x86/boot/bzImage
#kernel=/home/vishal/project/TCLocks/src/kernel/linux-5.14.16/arch/x86/boot/bzImage

#image=disk1.img #temp.qcow2
image=tclocks-vm.img
#image=focal-server-cloudimg-amd64.img

#sudo qemu-system-x86_64 --enable-kvm -nographic \
#	-cpu host -smp cores=20,threads=1,sockets=1 \
#	-m 32G -overcommit mem-lock=off \
#	-object memory-backend-ram,size=32G,id=nr0 \
#	-numa node,nodeid=0,memdev=nr0,cpus=0-19 \
#	-drive file=$image,index=0,format=qcow2 \
#	-qmp tcp:127.0.0.1:8888,server,nowait \
#	-device virtio-net-pci,netdev=hostnet0,id=net0,bus=pci.0,addr=0x3 \
#	-netdev user,id=hostnet0,hostfwd=tcp::9999-:22 \
#	-netdev tap,id=br0,vhost=on,script=no,downscript=no \
#	-device virtio-net-pci,netdev=br0,id=nic1,bus=pci.0,addr=0x4 \
#	-kernel $kernel \
#	-append "root=/dev/sda1 console=ttyS0 nokaslr maxcpus=250 nr_cpus=250 possible_cpus=250 panic=1 numa_spinlock=on" \
#	-initrd komb-ramdisk.img \
#
#exit

sudo qemu-system-x86_64 --enable-kvm -nographic \
	-cpu host -smp cores=10,threads=1,sockets=2 \
	-m 32G -overcommit mem-lock=off \
	-object memory-backend-ram,size=16G,id=nr0 \
	-numa node,nodeid=0,memdev=nr0,cpus=0-9 \
	-object memory-backend-ram,size=16G,id=nr1 \
	-numa node,nodeid=1,memdev=nr1,cpus=10-19 \
	-drive file=$image,index=0,format=qcow2 \
	-qmp tcp:127.0.0.1:8888,server,nowait \
	-device virtio-net-pci,netdev=hostnet0,id=net0,bus=pci.0,addr=0x3 \
	-netdev user,id=hostnet0,hostfwd=tcp::9999-:22 \
	-netdev tap,id=br0,vhost=on,script=no,downscript=no \
	-device virtio-net-pci,netdev=br0,id=nic1,bus=pci.0,addr=0x4 \
	-kernel $kernel \
	-append "root=/dev/sda1 console=ttyS0 nokaslr maxcpus=250 nr_cpus=250 possible_cpus=250 panic=1" \
	-initrd komb-ramdisk.img \

	#-fsdev local,id=test_dev,path=/home/vishal/kcombiner/src/kernel,security_model=passthrough,multidevs=remap \
	#-device virtio-9p-pci,fsdev=test_dev,mount_tag=kcombiner \
