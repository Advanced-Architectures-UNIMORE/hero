ROOT := $(patsubst %/,%, $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
COMMON_ROOT := $(ROOT)/inc/common

only = pulp
CSRCS = $(wildcard *.c)

############################ OpenMP Sources ############################
CC := clang
LINK := llvm-link
COB := clang-offload-bundler
DIS := llvm-dis

TARGET_DEV = riscv32-hero-unknown-elf
ARCH_DEV = openmp-$(TARGET_DEV)
DEV_OBJDUMP := $(TARGET_DEV)-objdump

ifeq ($(strip $(opt)),)
  opt = 3
endif

.DEFAULT_GOAL = all
DEFMK_ROOT := $(patsubst %/,%, $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

CFLAGS_COMMON += $(cflags) -fopenmp=libomp -O$(opt) -static -fhero-device-default-as=device
CFLAGS_PULP += $(CFLAGS_COMMON) -target $(TARGET_DEV) -I$(HERO_HOST_INC_DIR) -I$(HERO_PULP_INC_DIR)
LDFLAGS_COMMON ?= $(ldflags) -static
LDFLAGS_PULP += $(LDFLAGS_COMMON)

INCPATHS += -I$(DEFMK_ROOT) -include $(COMMON_ROOT)/hero_64.h
LIBPATHS ?=

BENCHMARK = $(shell basename `pwd`)
EXE = $(BENCHMARK)
SRC = $(CSRCS)

DEPDIR := .deps
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.d

AS_ANNOTATE_ARGS ?=

RG := $(COMMON_ROOT)/rg

only ?=

.PHONY: all exe clean
.PRECIOUS: %.ll

all : $(DEPS) $(EXE) $(EXE).dis slm

%.ll: %.c $(DEPDIR)/%.d | $(DEPDIR)
	$(CC) -c -emit-llvm -S $(DEPFLAGS) $(CFLAGS_PULP) $(INCPATHS) $<

%.OMP.ll: %.ll
	cp $< $(<:.ll=.TMP.1.ll)
	hc-omp-pass $(<:.ll=.TMP.1.ll) OmpKernelWrapper "HERCULES-omp-kernel-wrapper" $(<:.ll=.TMP.2.ll)
	hc-omp-pass $(<:.ll=.TMP.2.ll) OmpHostPointerLegalizer "HERCULES-omp-host-pointer-legalizer" $(<:.ll=.TMP.3.ll)
	cp $(<:.ll=.TMP.3.ll) $(<:.ll=.OMP.ll)

$(EXE): $(SRC:.c=.OMP.ll)
	$(CC) $(LIBPATHS) $(CFLAGS_PULP) $^ $(LDFLAGS_PULP) -o $@

slm: $(EXE)_l1.slm $(EXE)_l2.slm

$(EXE)_l2.slm: $(EXE)
	$(DEV_OBJDUMP) -s --start-address=0x1c000000 --stop-address=0x1cffffff $^ | $(RG) '^ ' | cut -c 2-45 \
      | sort \
      > $@
	$(COMMON_ROOT)/one_word_per_line.py $@

$(EXE)_l1.slm: $(EXE)
	$(DEV_OBJDUMP) -s --start-address=0x10000000 --stop-address=0x1bffffff $^ | $(RG) '^ ' | cut -c 2-45 \
      | perl -p -e 's/^1b/10/' \
      | sort \
      > $@
	$(COMMON_ROOT)/one_word_per_line.py $@

$(EXE).dis: $(EXE)
	$(DEV_OBJDUMP) -d $^ > $@

$(DEPDIR):
	@mkdir -p $@

DEPFILES := $(CSRCS:%.c=$(DEPDIR)/%.d)
$(DEPFILES):

include $(wildcard $(DEPFILES))

clean::
	-rm -vf __hmpp* $(EXE) *~ *.bc *.dis *.i *.lh *.lk *.ll *.o *.s *.slm *.tmp
	-rm -rvf $(DEPDIR)

init-target-host:
ifndef HERO_TARGET_HOST
	$(error HERO_TARGET_HOST is not set)
endif
	ssh -t $(HERO_TARGET_HOST) './sourceme.sh'
	ssh -t $(HERO_TARGET_HOST) 'rmmod -f pulp'
	ssh -t $(HERO_TARGET_HOST) 'insmod $(HERO_TARGET_PATH_DRIVER)/pulp.ko'

prepare:: init-target-host $(EXE)
ifndef HERO_TARGET_HOST
	$(error HERO_TARGET_HOST is not set)
endif
	ssh $(HERO_TARGET_HOST) "mkdir -p $(HERO_TARGET_PATH_APPS)"
	scp $(EXE) $(HERO_TARGET_HOST):$(HERO_TARGET_PATH_APPS)/.

run:: prepare $(EXE)
ifeq ($(call ifndef_any_of,HERO_TARGET_HOST HERO_TARGET_PATH_APPS HERO_TARGET_PATH_LIB),)
	ssh -t $(HERO_TARGET_HOST) 'export LD_LIBRARY_PATH='"'$(HERO_TARGET_PATH_LIB)'"'; cd ${HERO_TARGET_PATH_APPS}; ./$(EXE) $(RUN_ARGS)'
else
	$(error HERO_TARGET_HOST and/or HERO_TARGET_PATH_APPS is not set)
endif
