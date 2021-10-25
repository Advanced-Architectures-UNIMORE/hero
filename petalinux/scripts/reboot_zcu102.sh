#!/usr/bin/env bash

error_exit()
{
  echo -e "\n$1\n" 1>&2
  exit 1
}

readonly HERO_ROOT="$HERO_HOME_DIR"

# reboot
# ssh $HERO_TARGET_HOST /sbin/reboot

# Load libraries
if [ -n "$HERO_TARGET_HOST" ]; then
    scp $HERO_ROOT/output/br-har-exilzcu102/target/usr/lib/libhero-target.so $HERO_TARGET_HOST:/lib
    scp $HERO_ROOT/output/br-har-exilzcu102/target/usr/lib/libomp.so $HERO_TARGET_HOST:/lib
    scp $HERO_ROOT/output/br-har-exilzcu102/target/usr/lib/libomptarget.so $HERO_TARGET_HOST:/lib
else
  error_exit "HERO_TARGET_HOST is not defined. Aborting."
fi

# load pulp driver
if [ -n "$HERO_TARGET_HOST" ]; then
    ssh $HERO_TARGET_HOST "mkdir /lib/modules/4.19.0/extra"
    scp $HERO_HOME_DIR/output/br-har-exilzcu102/target/lib/modules/4.19.0/extra/pulp.ko $HERO_TARGET_HOST:/lib/modules/4.19.0/extra
    ssh $HERO_TARGET_HOST "rmmod -f pulp"
    ssh $HERO_TARGET_HOST "insmod /lib/modules/4.19.0/extra/pulp.ko"
else
    error_exit "HERO_TARGET_HOST is not defined. Aborting."
fi