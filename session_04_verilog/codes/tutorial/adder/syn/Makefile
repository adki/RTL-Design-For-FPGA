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

all: synthesis

synthesis:
	-@/bin/rm -f ${TOP}.ngc
	(export device_target=${DEV};\
	export top_target=${TOP};\
	export inc_dir=${INCD};\
	export design=xst_list.xst;\
	${XST} -ifn xst_option.xst -ofn ${TOP}.log;)
	${NGC} -bd angle -w ${TOP}.ngc ${TOP}.edif
	${NET} -w -ofmt verilog ${TOP}.ngc ${TOP}_gate.v
#	cp ${TOP}.edif ../${TOP}.edif

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
