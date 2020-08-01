#------------------------------------------------------------------
# Copyright (c) 2013 by Ando Ki.
# All right reserved.
#
# This code is distributed in the hope that it will
# be useful to understand Ando Ki's book,
# but WITHOUT ANY WARRANTY.
#------------------------------------------------------------------
SHELL		= /bin/sh
MAKEFILE	= Makefile
#------------------------------------------------------------------
WORK	= work
VLOG	= $(shell which vlogcomp)
FUSE	= $(shell which fuse)
SIM	= my_sim
TOP	= top
#--------------------------------------------------------
all: vlib compile elaboration simulate

vlib:
	if [ -d $(WORK) ]; then /bin/rm -rf $(WORK); fi

compile:
	($(VLOG) -work $(WORK) -f isim.args || exit 1) 2>&1 | tee vlog.log

elaboration: compile
	$(FUSE) -o $(SIM) $(WORK).$(TOP)\
		-L unisims_ver -L unimacro_ver -L xilinxcorelib_ver\
		|| exit 1

simulate: $(SIM)
	./$(SIM) -tclbatch isim.tcl -log $(SIM).log || exit 1
#	./$(SIM) -tclbatch isim.tcl -log $(SIM).log -vcdfile wave.vcd || exit 1

$(SIM): elaboration

gui: $(SIM)
	./$(SIM) -gui -view wave.wcfg -log $(SIM).log || exit 1
#	./$(SIM) -gui -view wave.wcfg -wdb wave.vcd -tclbatch isim.tcl -log $(SIM).log || exit 1

#--------------------------------------------------------
clean:
	-@/bin/rm -rf $(WORK)
	-@/bin/rm -f  transcript
	-@/bin/rm -f  wave.vcd dump.vcd
	-@/bin/rm -f  vsim.wlf
	-@/bin/rm -f  vish_stacktrace.vstf
	-@/bin/rm -f  m.args
	-@/bin/rm -f  mc.args
	-@/bin/rm -f  mx.args
	-@/bin/rm -f  x.txt xx.txt
	-@/bin/rm -f  wlft*
	-@/bin/rm -f  vlog.log
	-@/bin/rm -f  fuse.log
	-@/bin/rm -fr isim
	-@/bin/rm -f  isim.log
	-@/bin/rm -f  isim.wdb
	-@/bin/rm -f  $(SIM).exe
	-@/bin/rm -f  $(SIM).log

cleanup: clean

clobber: cleanup

#--------------------------------------------------------
