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
XST	= $(shell which xst)
NGC	= $(shell which ngc2edif)
NET	= $(shell which netgen)
WORK	= work
DEV	= xc3s1000-fg456-4
INCD	= ../design
TOP	= full_adder
#--------------------------------------------------------

all: NGD MAP PAR

NGD:
	ngdbuild -a -p ${DEV} -sd ../syn -dd . ${TOP} ${TOP}.ngd

MAP:
	map -p ${DEV} -o ${TOP}.ncd ${TOP}.ngd ${TOP}.pcf

PAR:
	par -w ${TOP}.ncd ${TOP}.ncd ${TOP}.pcf

clean:
	-@/bin/rm -f compile.log
	-@/bin/rm -f ngc2edif.log
	-@/bin/rm -rf ./xst
	-@/bin/rm -f compile.ngc
	-@/bin/rm -f ${TOP}.xncf
	-@/bin/rm -f ${TOP}.log
	-@/bin/rm -f ${TOP}.edif
	-@/bin/rm -f ${TOP}.ngc
	-@/bin/rm -f ${TOP}.lso
	-@/bin/rm -f ${TOP}.nlf
	-@/bin/rm -rf xlnx_auto_0_xdb
	-@/bin/rm -f *_xst.xrpt
	-@/bin/rm -f xlnx_auto_0.ise
	-@/bin/rm -f ${TOP}_gate.v
	-@/bin/rm -f ${TOP}_gate.nlf

cleanup: clean
	-@/bin/rm -f ${TOP}.edif ../${TOP}.edif

clobber: cleanup
