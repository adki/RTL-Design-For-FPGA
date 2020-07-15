#------------------------------------------------------------------
# VIVADO Batch Mode 
#------------------------------------------------------------------
# Copyright (c) 2018 by Future Design Systems
# All right reserved.
#------------------------------------------------------------------
SHELL		= /bin/sh
MAKEFILE	= Makefile
#------------------------------------------------------------------
ifeq ("$(MAKECMDGOALS)", "all")
      skip=0
else ifeq ("$(MAKECMDGOALS)", "")
      skip=0
else
      skip=1
endif
ifneq ($(skip),1)
ifndef XILINX_VIVADO
       $(warning XILINX_VIVADO environment variable not defined)
endif
endif
#------------------------------------------------------------------
export VIVADO  = $(XILINX_VIVADO)/bin/vivado
export SOURCE_BRAM = project_bram.tcl	
export WORK    = work
export MACRO   = MACRO
export DEVICE  = xc7z020clg484-1
export SIZE_KB = 1
export WIDTH   = 32
#export DEPTH   = $(shell expr $(SIZE_KB)\*1024\*8/$(WIDTH))
export DEPTH   = $(shell echo $$(( $(SIZE_KB)\*1024\*8/$(WIDTH) )))
export MODULE  = bram_$(WIDTH)x$(SIZE_KB)KB
export GUI    ?= 0

#------------------------------------------------------------------
all:
	echo $(DEPTH)
	if [ "$(GUI)" = "1" ]; then\
		$(VIVADO) -mode gui -source $(SOURCE_BRAM);\
	else\
		$(VIVADO) -mode batch -source $(SOURCE_BRAM);\
	fi

#------------------------------------------------------------------
clean:
	-@/bin/rm -rf ./.Xil
	-@/bin/rm -rf $(WORK)
	-@/bin/rm -f  ./*.html
	-@/bin/rm -f  ./*.xml
	-@/bin/rm -f  ./vivado*.jou
	-@/bin/rm -f  ./vivado*.log
	-@/bin/rm -f  ./*.backup.*
	-@/bin/rm -f  ./planAhead.*
	-@/bin/rm -f  fsm_encoding.os
	-@/bin/rm -rf ip_user_files
	-@/bin/rm -rf managed_ip_project

cleanup clobber: clean

cleanupall: cleanup
	for D in $(DEPTH_ALL); do\
		/bin/rm -rf bram_32x$${D}KB;\
	done
