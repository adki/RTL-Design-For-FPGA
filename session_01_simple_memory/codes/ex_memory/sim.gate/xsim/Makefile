VIVADO_VERSION = $(shell vivado -version | sed -n 1p | cut -d" " -f 2 | cut -c 2-7)
export FPGA_TYPE=zusp
export VIVADO=vivado.$(VIVADO_VERSION)

all: elab sim

elab:
	xelab -prj xsim.prj -debug typical -L secureip -L unisims_ver -L unimacro_ver top glbl -s top
	$(eval UU:=$(shell grep "undeclared symbol" xelab.log | wc -l))
	@if [ ${UU} != 0 ]; then echo "ERROR undeclared symbol";\
	else echo "OK"; fi

sim:
	xsim top -t xsim_run.tcl
#	xsim top -gui -t xsim_run.tcl

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

cleanup: clean

cleanupall: cleanup
