#!/usr/bin/env bash

readonly THIS_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
readonly HERO_ROOT=$HERO_HOME_DIR

# reboot
# ssh root@hero-zcu102-08 /sbin/reboot

# load libraries
scp $HERO_HOME_DIR/output/br-har-exilzcu102/target/usr/lib/libhero-target.so root@hero-zcu102-08:/lib
scp $HERO_HOME_DIR/output/br-har-exilzcu102/target/usr/lib/libomp.so root@hero-zcu102-08:/lib
scp $HERO_HOME_DIR/output/br-har-exilzcu102/target/usr/lib/libomptarget.so root@hero-zcu102-08:/lib

# load pulp driver
# ssh hero-zcu102-08 "mkdir /lib/modules/4.19.0/extra"
# scp $HERO_HOME_DIR/output/br-har-exilzcu102/target/usr/lib/libhero-target.so root@hero-zcu102-08:/lib/modules/4.19.0/extra
# insmod /mnt/lib/modules/4.19.0/extra/pulp.ko