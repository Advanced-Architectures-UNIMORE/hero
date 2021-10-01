# Access project folder
cd zcu102

CONFIG_FILE=$THIS_DIR/../local.cfg
OUTPUT_DIR=$THIS_DIR/../output
IMAGES=${OUTPUT_DIR}/br-har-exilzcu102/images
ROOTFS=${OUTPUT_DIR}/br-har-exilzcu102/images

# Export Image and device-tree
ssh gbellocchi@155.185.4.26 rm -f /opt/tftpboot/gbellocchi/*
scp ${IMAGES}/Image ${IMAGES}/system.dtb gbellocchi@155.185.4.26:/opt/tftpboot/gbellocchi/

# Export rootfs
ssh gbellocchi@155.185.4.26 rm -rf /opt/rootfs/gbellocchi/*
ssh gbellocchi@155.185.4.26 rm -rf rootfs.tar
scp ${ROOTFS}/rootfs.tar gbellocchi@155.185.4.26:~
ssh gbellocchi@155.185.4.26 tar -xf ~/rootfs.tar -C /opt/rootfs/gbellocchi/

# Reset board
cd ../
xsdb reset-31212.tcl
cd zcu102

# Load bitstream and fsbl
petalinux-boot --jtag --u-boot --fpga --bitstream ../../hardware/fpga/hero_exilzcu102/hero_exilzcu102.runs/impl_1/hero_exilzcu102_wrapper.bit -v --hw_server-url 155.185.4.26:31212
# Esp PULP double prefetch (TCDM-BRAM)
# petalinux-boot --jtag --u-boot --fpga --bitstream ../../hardware/fpga/hero_hwpe_fpga/hero_exizcu102_MMULT_OPT_ff/hero_exilzcu102.runs/impl_1/hero_exilzcu102_wrapper.bit -v --hw_server-url 155.185.4.26:31212
# Esp PULP parallelism
# petalinux-boot --jtag --u-boot --fpga --bitstream ../../hardware/fpga/hero_hwpe_fpga/hero_exizcu102_MMULT_PARALLEL_ff/hero_exilzcu102.runs/impl_1/hero_exilzcu102_wrapper.bit -v --hw_server-url 155.185.4.26:31212

# # Connect to the board
# ssh wks-marongiu1.mat.unimo.it

# # Serial terminal
# killall -9 minicom
# # minicom usb0

# # # Run these commands on minicom
# setenv tftpblocksize 512

# # # /opt/rootfs/gbellocchi
# # setenv bootargs console=ttyPS0,115200n8 earlycon clk_ignore_unused cpuidle.off=1 ip=155.185.4.7:155.185.4.26:155.185.5.254:255.255.254.0::eth0:off root=/dev/nfs rootfstype=nfs nfsroot=155.185.4.26:/opt/rootfs/gbellocchi,tcp,nolock,nfsvers=3 rw uio_pdrv_genirq.of_id=generic-uio cma=256M
# setenv bootargs console=ttyPS0,115200n8 earlycon clk_ignore_unused ip=155.185.4.7:155.185.4.26:155.185.5.254:255.255.254.0::eth0:off root=/dev/nfs rootfstype=nfs nfsroot=155.185.4.26:/opt/hero/rootfs,tcp,nolock,nfsvers=3 rw

# # # /opt/hero/rootfs
# # setenv bootargs console=ttyPS0,115200n8 earlycon clk_ignore_unused cpuidle.off=1 ip=155.185.4.7:155.185.4.26:155.185.5.254:255.255.254.0::eth0:off root=/dev/nfs rootfstype=nfs nfsroot=155.185.4.26:/opt/hero/rootfs,tcp,nolock,nfsvers=3 rw uio_pdrv_genirq.of_id=generic-uio cma=256M

# tftpb 0x200000 gbellocchi/Image
# tftpb 0x7000000 gbellocchi/system.dtb
# booti 0x200000 - 0x7000000 ${bootargs}

# # login -> user: root / pw: root
# # check the uio-dev name in /sys/class/uio -> 
# #     cat uio#/name -> 
# #     customize the initialization API arguments in the application
# #     zynq serverip=155.185.4.26
