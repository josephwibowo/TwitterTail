#!/usr/bin/env bash
MACHINENAME=$1
ISO=lubuntu-19.10-desktop-amd64.iso
# Download lubuntu.iso on mac osx. WARNING: 1.5gb iso
if [ ! -f ./${ISO} ]; then
    curl -O http://cdimage.ubuntu.com/lubuntu/releases/19.10/release/${ISO}
fi

#CreateVM
VBoxManage createvm --name $MACHINENAME --ostype "Linux 2.6 / 3.x / 4.x (64-bit)" --register
#Set memory and network
VBoxManage modifyvm $MACHINENAME --ioapic on
VBoxManage modifyvm $MACHINENAME --memory 2048 --vram 128
VBoxManage modifyvm $MACHINENAME --nic1 bridged --bridgeadapter1 'en0: Wi-Fi (AirPort)'
VBoxManage modifyvm $MACHINENAME --nic2 bridged --bridgeadapter2 'en0: Wi-Fi (AirPort)'
#Create Disk and connect Debian Iso
VBoxManage createhd --filename `pwd`/${MACHINENAME}/${MACHINENAME}_DISK.vdi --size 80000 --format VDI
VBoxManage storagectl $MACHINENAME --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $MACHINENAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  `pwd`/$MACHINENAME/${MACHINENAME}_DISK.vdi
VBoxManage storagectl $MACHINENAME --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach $MACHINENAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium `pwd`/${ISO}
VBoxManage modifyvm $MACHINENAME --boot1 dvd --boot2 disk --boot3 none --boot4 none

#Start the VM
VBoxManage startvm $MACHINENAME