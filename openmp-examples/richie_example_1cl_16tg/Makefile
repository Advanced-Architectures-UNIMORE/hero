ROOT := $(patsubst %/,%, $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

CSRCS = $(wildcard *.c)

-include $(HERO_OV_OPENMP_TESTS)/common/default.mk

INCPATHS += -I$(PULP_SDK_HOME)/install/include

# Link PULP libraries
CFLAGS_PULP += -g -include $(PULP_SDK_HOME)/install/hero/hero-sim/cl_config.h
LDFLAGS_PULP += -lomptarget-pulp -lrt

# Link RICHIE library
LIBPATHS += -L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/librichie-target/lib/
LDFLAGS_PULP += -lrichie-target
LDFLAGS += -lrichie-target

# Link HWPE libraries
LIBPATHS += -L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic0/lib/hwpe_cl0_lic0 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic1/lib/hwpe_cl0_lic1 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic2/lib/hwpe_cl0_lic2 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic3/lib/hwpe_cl0_lic3 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic4/lib/hwpe_cl0_lic4 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic5/lib/hwpe_cl0_lic5 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic6/lib/hwpe_cl0_lic6 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic7/lib/hwpe_cl0_lic7 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic8/lib/hwpe_cl0_lic8 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic9/lib/hwpe_cl0_lic9 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic10/lib/hwpe_cl0_lic10 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic11/lib/hwpe_cl0_lic11 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic12/lib/hwpe_cl0_lic12 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic13/lib/hwpe_cl0_lic13 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic14/lib/hwpe_cl0_lic14 \
			-L$(HERO_SDK_DEV)/lib/$(RICHIE_PLATFORM)/libhwpe/hwpe_cl0_lic15/lib/hwpe_cl0_lic15

LDFLAGS_PULP += -lhwpe_cl0_lic0 \
				-lhwpe_cl0_lic1 \
				-lhwpe_cl0_lic2 \
				-lhwpe_cl0_lic3 \
				-lhwpe_cl0_lic4 \
				-lhwpe_cl0_lic5 \
				-lhwpe_cl0_lic6 \
				-lhwpe_cl0_lic7 \
				-lhwpe_cl0_lic8 \
				-lhwpe_cl0_lic9 \
				-lhwpe_cl0_lic10 \
				-lhwpe_cl0_lic11 \
				-lhwpe_cl0_lic12 \
				-lhwpe_cl0_lic13 \
				-lhwpe_cl0_lic14 \
				-lhwpe_cl0_lic15

LDFLAGS += 	-lhwpe_cl0_lic0 \
			-lhwpe_cl0_lic1 \
			-lhwpe_cl0_lic2 \
			-lhwpe_cl0_lic3 \
			-lhwpe_cl0_lic4 \
			-lhwpe_cl0_lic5 \
			-lhwpe_cl0_lic6 \
			-lhwpe_cl0_lic7 \
			-lhwpe_cl0_lic8 \
			-lhwpe_cl0_lic9 \
			-lhwpe_cl0_lic10 \
			-lhwpe_cl0_lic11 \
			-lhwpe_cl0_lic12 \
			-lhwpe_cl0_lic13 \
			-lhwpe_cl0_lic14 \
			-lhwpe_cl0_lic15