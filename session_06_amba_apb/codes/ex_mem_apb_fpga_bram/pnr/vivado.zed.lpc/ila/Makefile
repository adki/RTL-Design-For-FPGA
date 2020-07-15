#------------------------------------------------------------------
# VIVADO Batch Mode 
#------------------------------------------------------------------
# Copyright (c) 2016 by Future Design Systems.
# All right reserved.
#------------------------------------------------------------------
SHELL		= /bin/sh
MAKEFILE	= Makefile
#------------------------------------------------------------------
export VIVADO = $(XILINX_VIVADO)/bin/vivado
export PROJECT_DIR = project_1
export PROJECT_NAME = project_1
export SOURCE = vivado_ila.tcl
export WORK   = work
export DEVICE = xc7z020-clg484-1
export MODULE = fpga
export BOARD  = BOARD_ZED
export EDIF   =

export XDC_SRC= ../xdc/fpga_etc.xdc\
                ../xdc/fpga_zed.xdc\
                ../xdc/con-fmc_lpc_zed.xdc

export XDC_ILA= xdc.ila/fpga_etc.xdc\
                xdc.ila/fpga_zed.xdc\
                xdc.ila/con-fmc_lpc_zed.xdc\
                xdc.ila/ila.xdc

#------------------------------------------------------------------
all: xdc vivado

vivado:
	$(VIVADO) -mode gui -source $(SOURCE) &

#------------------------------------------------------------------
export ila_bit=${PROJECT_DIR}/${PROJECT_NAME}.runs/impl_1/fpga.bit
export ila_ltx=${PROJECT_DIR}/${PROJECT_NAME}.runs/impl_1/fpga.ltx
bit:
	@if [ ! -f ${ila_bit} ]; then\
		echo "${ila_bit} not fould.";\
		exit 1;\
	else\
		cp ${ila_bit} fpga_ila.bit;\
	fi
	@if [ ! -f ${ila_ltx} ]; then\
		echo "${ila_ltx} not fould.";\
		exit 1;\
	else\
		cp ${ila_ltx} fpga_ila.ltx;\
	fi

xdc:
	if [ ! -d xdc.ila ]; then mkdir xdc.ila; fi
	for X in $(XDC_SRC); do\
		if [ -f $$X ]; then /bin/cp $$X xdc.ila; fi;\
	done
	if [ ! -f xdc.ila ]; then\
		echo -n "" > xdc.ila/ila.xdc;\
	fi

#------------------------------------------------------------------
DIRS    = $(subst /,, $(dir $(wildcard */Makefile)))

clean:
	-@/bin/rm -rf .Xil
	-@/bin/rm -rf $(WORK)
	-@/bin/rm -f  *.html
	-@/bin/rm -f  *.xml
	-@/bin/rm -f  *.jou
	-@/bin/rm -f  *.backup*
	-@/bin/rm -f  planAhead.*
	-@/bin/rm -f  vivado.log
	-@/bin/rm -f  vivado_pid*.str  vivado_pid*.debug
	-@/bin/rm -fr .cache .sim
	-@/bin/rm -fr project_1
	-@/bin/rm -f  report_inter-Clock-Paths.xlsx warning.txt
	for D in $(DIRS); do\
		if [ -f $$D/Makefile ] ; then \
			echo "make -C $$D -s $@";\
			make -C $$D -s $@;\
		fi;\
	done

cleanup clobber: clean
	-@/bin/rm -rf ./*.log
	-@/bin/rm -rf $(MODULE).ucf
	-@/bin/rm -rf $(MODULE).ut
	-@/bin/rm -rf $(MODULE).tcf
	for D in $(DIRS); do\
		if [ -f $$D/Makefile ] ; then \
			echo "make -C $$D -s $@";\
			make -C $$D -s $@;\
		fi;\
	done

cleanupall: cleanup
	-@/bin/rm -rf $(MODULE).bit
	for D in $(DIRS); do\
		if [ -f $$D/Makefile ] ; then \
			echo "make -C $$D -s $@";\
			make -C $$D -s $@;\
		fi;\
	done
	/bin/rm -f  fpga_ila.bit
	/bin/rm -f  fpga_ila.ltx
	/bin/rm -fr xdc.ila
