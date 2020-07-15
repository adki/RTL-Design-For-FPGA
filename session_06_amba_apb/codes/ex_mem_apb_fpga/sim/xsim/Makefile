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
ifndef CONFMC_HOME
       $(warning CONFMC_HOME environment variable not defined)
       export CONFMC_HOME=${HOME}/work/projects/ez-usb-fx3
endif
VIVADO_VERSION = $(shell vivado -version | sed -n 1p | cut -d" " -f 2 | cut -c 2-)
endif

export FPGA_TYPE=z7
export VIVADO=vivado.$(VIVADO_VERSION)

all: elab sim

elab:
	xelab -prj xsim.prj -debug typical -L secureip -L unisims_ver -L unimacro_ver top glbl -s top

sim:
	xsim top -t xsim_run.tcl
#	xsim top -gui -t xsim_run.tcl

#all:
#	xvlog ${XILINX_VIVADO}/data/verilog/src/glbl.v
#	xelab -debug typical -L secureip -L unisims_ver -L unimacro_ver top glbl -s top_sim 
#
#all:
#	xvlog file1.v
#	xvhdl file2.vhd
#	xvlog top.v
#	xelab -debug typical top -s top
#	xsim top -t xsim_run.tcl

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
	/bin/rm -f  data_fixed.txt  data_float.txt  fft_fixed.txt  fft_float.txt
	/bin/rm -f  ifft_fixed.txt  ifft_float.txt

cleanup: clean

cleanupall: cleanup
