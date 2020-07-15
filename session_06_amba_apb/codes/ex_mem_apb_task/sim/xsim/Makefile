#------------------------------------------------------------------
# Copyright (c) 2019 by Ando Ki.
# All right reserved.
#------------------------------------------------------------------
# simulation
# $ make
#
# plot signal & fft-result in the memory using Python
# $ make plot
#
# plot data & fft-rsult on the AXIS bus using GNUPLOT
# $ make plot_data
# $ make plot_fft
#------------------------------------------------------------------
SHELL=/bin/bash
MAKEFILE	= Makefile
#------------------------------------------------------------------
ifeq ("$(MAKECMDGOALS)", "all")
      skip=0
else ifeq ("$(MAKECMDGOALS)", "")
      skip=0
else
      skip=1
endif
#------------------------------------------------------------------
ifneq ($(skip),1)
ifndef XILINX_VIVADO
       $(warning XILINX_VIVADO environment variable not defined)
endif
VIVADO_VERSION = $(shell vivado -version | sed -n 1p | cut -d" " -f 2 | cut -c 2-)
endif
#------------------------------------------------------------------
export TOP	 = top
export FPGA_TYPE = z7
export VIVADO    = vivado.$(VIVADO_VERSION)
export DIR_FIP   = ../../..
export GUI      ?= 0
#------------------------------------------------------------------

all: elab sim

elab:
	@xelab -prj xsim.prj -debug typical\
		${TOP} -s ${TOP};

sim:
	@if [ "$(GUI)" = "1" ]; then xsim top -gui;\
	else xsim ${TOP} -testplusarg VCD=1 -t xsim_run.tcl; fi

gui: elab
	xsim top -gui

#--------------------------------------------------------
clean:
	/bin/rm -f  top.wdb
	/bin/rm -f  wave.vcd
	/bin/rm -f  webtalk_*.backup.jou
	/bin/rm -f  webtalk_*.backup.log
	/bin/rm -f  webtalk.jou
	/bin/rm -f  webtalk.log
	/bin/rm -f  xelab.log
	/bin/rm -f  xelab.pb
	/bin/rm -fr .Xil/
	/bin/rm -f  xsim_*.backup.jou
	/bin/rm -f  xsim_*.backup.log
	/bin/rm -fr xsim.dir/
	/bin/rm -f  xsim.jou
	/bin/rm -f  xsim.log
	/bin/rm -f  xvlog.log
	/bin/rm -f  xvlog.pb
	/bin/rm -f  transcript
	/bin/rm -f  wave.wlf

cleanup clobber: clean 
	/bin/rm -rf project_1

cleanupall distclean: cleanup
