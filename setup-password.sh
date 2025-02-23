#!/bin/bash

help="Setup VM password on the first boot.\nUsage: ./setup-password.sh [disk] [password]"

disk=$1
if test $disk = "-h"; then
    echo $help; exit
fi

if test $disk = ""; then
    echo "missing argument."
    echo $help; exit
fi

password=$2

if test $password = ""; then
    echo "missing argument."
    echo $help; exit
fi

echo "#cloud-config 
password: $password 
chpasswd: { expire: False }
ssh_pwauth: True" > user-data

genisoimage -output tmp-seed.iso -volid cidata -joliet -rock user-data meta-data

sudo qemu-system-x86_64 \
	--enable-kvm \
    -nographic \
    -m 8G \
    -cpu host \
    -smp 4 \
    -drive file=$disk,index=1,format=qcow2 \
    -drive file=./tmp-seed.iso,index=0,if=virtio,format=raw \
    -device virtio-net-pci,netdev=hostnet0,id=net0,bus=pci.0,addr=0x3 \
    -netdev user,id=hostnet0,hostfwd=tcp::9999-:22 \
   
rm tmp-seed.iso user-data
