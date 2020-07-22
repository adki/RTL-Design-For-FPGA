#------------------------------------------------------------------
# VIVADO Batch Mode 
#------------------------------------------------------------------
# Copyright (c) 2018 by Future Design Systems
# All right reserved.
#------------------------------------------------------------------
SHELL		= /bin/sh
MAKEFILE	= Makefile
#-------------------------------------------------------------------------------
ifeq ("$(MAKECMDGOALS)", "all")
      skip=0
else ifeq ("$(MAKECMDGOALS)", "")
      skip=0
else
      skip=1
endif
#-------------------------------------------------------------------------------
ifneq ($(skip),1)
ifndef XILINX_VIVADO
       $(warning XILINX_VIVADO environment variable not defined)
endif
export VIVADO_VERSION = $(shell vivado -version | sed -n 1p | cut -d" " -f 2 | cut -c 2-)
export VIVADO_VER=vivado.$(VIVADO_VERSION)
ifndef CONFMC_HOME
       $(warning CONFMC_HOME environment variable not defined)
       export CONFMC_HOME=${HOME}/work/projects/ez-usb-fx3
endif
endif
#------------------------------------------------------------------
export VIVADO = $(XILINX_VIVADO)/bin/vivado
export PROJECT_DIR = project_1
export PROJECT_NAME = project_1
export SOURCE = vivado_project.tcl
export WORK   = work
export DEVICE = xc7z020-clg484-1
export MODULE = fpga
export BOARD  = BOARD_ZED
export RIGOR  = 1
export GUI   ?= 1

FLOG	= $(MODULE)
#------------------------------------------------------------------
all: vivado 

vivado:
	if [ "$(GUI)" = "1" ]; then\
		$(VIVADO) -mode gui -source $(SOURCE);\
	else\
		$(VIVADO) -mode batch -source $(SOURCE);\
	fi

#------------------------------------------------------------------
DIRS    = $(subst /,, $(dir $(wildcard */Makefile)))

clean:
	-@/bin/rm -rf .Xil
	-@/bin/rm -rf work .cache
	-@/bin/rm -f  *.html
	-@/bin/rm -f  *.xml
	-@/bin/rm -f  *.jou
	-@/bin/rm -f  *.backup*
	-@/bin/rm -f  planAhead.*
	-@/bin/rm -f  vivado.log
	-@/bin/rm -f  vivado_pid*.str  vivado_pid*.debug
	-@/bin/rm -f  fsm_encoding.os
	-@/bin/rm -f  impact_impact.xwbt  impact.xsl webtalk.log
	-@/bin/rm -f  tight_setup_hold_pins.txt
	-@/bin/rm -f  target.xdc
	for D in $(DIRS); do\
		if [ -f $$D/Makefile ] ; then \
			echo "make -C $$D -s $@";\
			make -C $$D -s $@;\
		fi;\
	done

cleanup: clean
	-@/bin/rm -f  ./*.log
	-@/bin/rm -f  $(MODULE).ucf
	-@/bin/rm -f  $(MODULE).ut
	-@/bin/rm -f  $(MODULE).tcf
	-@/bin/rm -rf work
	-@/bin/rm -rf $(WORK)
	-@/bin/rm -rf $(MODULE).edn
	-@/bin/rm -rf $(MODULE).edif
	-@/bin/rm -rf $(MODULE).bit
	-@/bin/rm -rf $(PROJECT_DIR)
	for D in $(DIRS); do\
		if [ -f $$D/Makefile ] ; then \
			echo "make -C $$D -s $@";\
			make -C $$D -s $@;\
		fi;\
	done

cleanupall: cleanup
