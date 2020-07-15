#------------------------------------------------------------------
# VIVADO Batch Mode 
#------------------------------------------------------------------
# Copyright (c) 2018 by Future Design Systems
# All right reserved.
#------------------------------------------------------------------
SHELL		= /bin/sh
MAKEFILE	= Makefile
#------------------------------------------------------------------
export VIVADO             = $(XILINX_VIVADO)/bin/vivado
export VIVADO_VER         = vivado.$(shell vivado -version | grep Vivado | cut -d" " -f2 | cut -d"v" -f2 | cut -d"." -f1-2)
export PROJECT_DIR        = project_1
export PROJECT_NAME       = project_1
export WORK               = work
export FPGA_TYPE          = ZYNQ7000
export MODULES            = memory
export RIGOR              = 1
export SYNTH_ONLY         = 1
export GUI               ?= 0
#------------------------------------------------------------------
export SOURCE             =vivado_syn.tcl
#------------------------------------------------------------------
all: vivado

vivado:
	for M in ${MODULES}; do\
		export MODULE=$$M;\
		if [ "$(GUI)" = "1" ]; then\
			$(VIVADO) -mode gui -source $(SOURCE);\
		else\
			$(VIVADO) -mode tcl -source $(SOURCE);\
		fi;\
	done

install:
	for M in ${MODULES}; do\
		if [ -f $${M}.vm ]; then\
			cp $${M}.vm ../../rtl/verilog/$${M}_vivado.vm;\
			cp $${M}_stub.v ../../rtl/verilog/$${M}_stub.v;\
		fi;\
	done

#------------------------------------------------------------------
DIRS    = $(subst /,, $(dir $(wildcard */Makefile)))

clean:
	-/bin/rm -f  *.log
	-/bin/rm -fr .cache
	-/bin/rm -rf .Xil
	-/bin/rm -f  *.html
	-/bin/rm -f  *.xml
	-/bin/rm -f  *.jou
	-/bin/rm -f  *.backup*
	-/bin/rm -f  planAhead.*
	-/bin/rm -f  vivado.log
	-/bin/rm -f  vivado_pid*.str  vivado_pid*.debug
	-/bin/rm -f  fsm_encoding.os
	-/bin/rm -f  hw_ila_data_*btree
	-/bin/rm -rf $(WORK)
	for D in $(DIRS); do\
		if [ -f $$D/Makefile ] ; then \
			echo "make -C $$D -s $@";\
			make -C $$D -s $@;\
		fi;\
	done

cleanup clobber: clean
	for D in $(DIRS); do\
		if [ -f $$D/Makefile ] ; then \
			echo "make -C $$D -s $@";\
			make -C $$D -s $@;\
		fi;\
	done
	-@/bin/rm -rf project_*
	for M in ${MODULES}; do\
                /bin/rm -f  $${M}.xdc;\
                /bin/rm -rf $${M}.dcp;\
                /bin/rm -rf $${M}.vm;\
	done

cleanupall: cleanup
	for M in ${MODULES}; do\
                /bin/rm -rf $${M}.edn;\
                /bin/rm -rf $${M}.edif;\
                /bin/rm -rf $${M}_stub.v;\
	done
	for D in $(DIRS); do\
		if [ -f $$D/Makefile ] ; then \
			echo "make -C $$D -s $@";\
			make -C $$D -s $@;\
		fi;\
	done
#------------------------------------------------------------------
