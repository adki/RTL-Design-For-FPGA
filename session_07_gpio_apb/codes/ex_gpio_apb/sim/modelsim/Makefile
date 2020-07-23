#
# Copyright (c) 2008 by Ando Ki.
# All right reserved.
#
# This code is distributed in the hope that it will
# be useful to understand Ando Ki's book,
# but WITHOUT ANY WARRANTY.
#

SHELL		= /bin/sh
MAKEFILE	= Makefile

#--------------------------------------------------------
VLIB	= $(shell which vlib)
VLOG	= $(shell which vlog)
VSIM	= $(shell which vsim)
WORK	= work
TOP	= top

#--------------------------------------------------------
all: vlib compile simulate

vlib:
	$(VLIB)	$(WORK)

compile:
	$(VLOG) -lint -work $(WORK) -f modelsim.args

simulate: compile
	$(VSIM) -c -do "run -all; quit" $(WORK).$(TOP)

#--------------------------------------------------------
clean:
	-@/bin/rm -rf $(WORK)
	-@/bin/rm -f  transcript
	-@/bin/rm -f  wave.vcd dump.vcd
	-@/bin/rm -f  vsim.wlf
	-@/bin/rm -f  vish_stacktrace.vstf

cleanup: clean

clobber: cleanup

#--------------------------------------------------------
