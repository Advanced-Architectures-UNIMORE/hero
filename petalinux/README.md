# Petalinux
## Build Petalinux
To compile Petalinux for the target board (e.g. 'zcu102'), run:
```sh
make build_petalinux
```

The target can be modified acting on the Makefile parameter `target`. During the build phase, the Makefile runs a script that invokes all the necessary steps to build the Petalinux project and its images. The latters are then collected in the `output` directory running:
```sh
make update_output
```