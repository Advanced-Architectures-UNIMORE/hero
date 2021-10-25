# Petalinux
## Setup
A Makefile is provided with recipes to build the Petalinux project and update the exported image and bitstream. To ease the automation of these recipes, the user can modify a set of parameters in the Makefile:
```sh
# user parameters
TARGET_BOARD := zcu102 				# Board target (def: Xilinx ZCU102).
TARGET_HW := BR2_HERO_BITSTREAM		# Hardware target (def: BR2_HERO_BITSTREAM).
```
`TARGET_HW` is read from the configuration file `local.cfg`  at the root of the user repository. This alias is associated with the bitstream path that is imported during the Petalinux project creation. 

## Build Petalinux
To compile Petalinux for the target board (e.g. 'zcu102'), run:
```sh
make build_petalinux
```
During the build phase, the Makefile runs a script that invokes all the necessary steps to build the Petalinux project and its images. The latters are then collected in the `output` directory running:
```sh
make update_output
```

## Update the Linux environment
If the user needs to update the running Linux environment with a new bitstream, or  new Linux image, the following commands are exploitable:
```sh
make update_bitstream				# To update the hardware bitstream on the board.
make update_boardenv				# To update the Linux image on the board.
```

Once new files are exported, the board can be re-booted with `make reboot_zcu102`. Other than re-booting the system, the invoked script also update the HERO libraries and the PULP driver. The latters can be built in the `$HERO_HOME_DIR/support` directory.