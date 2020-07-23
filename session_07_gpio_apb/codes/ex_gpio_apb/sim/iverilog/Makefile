#------------------------------------------------------------------
SHELL		= /bin/sh
MAKEFILE	= Makefile
#--------------------------------------------------------
VLOG	= iverilog
VSIM	= vvp
#--------------------------------------------------------
TOP	= top
#--------------------------------------------------------
all: compile simulate

compile:
	($(VLOG) -o $(TOP).vvp -s $(TOP) -f iverilog.args\
		|| exit -1) 2>&1 | tee compile.log

simulate: compile
	$(VSIM) -l vvp.log $(TOP).vvp

#--------------------------------------------------------
clean:
	/bin/rm -f  $(TOP).vvp
	/bin/rm -f  compile.log
	/bin/rm -f  wave.vcd
	/bin/rm -f  vvp.log
	/bin/rm -f  data_fixed.txt  data_float.txt  fft_fixed.txt  fft_float.txt
	/bin/rm -f  ifft_fixed.txt  ifft_float.txt

cleanup clobber: clean

cleanupall: cleanup
#--------------------------------------------------------
