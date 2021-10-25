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