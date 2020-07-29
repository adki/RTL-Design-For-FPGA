#-------------------------------------------------------------------
# Copyright (c) 2013 by Ando Ki.
# All right reserved.
# 
# This code is distributed in the hope that it will
# be useful to understand Ando Ki's work,
# but WITHOUT ANY WARRANTY.
#

SHELL		= /bin/sh
MAKEFILE	= Makefile
#------------------------------------------------------------------
ARCH	= $(shell uname)
ifeq ($(ARCH), CYGWIN_NT-5.1)
else
ifeq ($(ARCH), MINGW32_NT-5.1)
else
endif
endif

#--------------------------------------------------------
XST	= $(shell which xst)
NGCB	= $(shell which ngcbuild)
NGCE	= $(shell which ngc2edif)
NETG	= $(shell which netgen)
WORK	= work
#--------------------------------------------------------
DEV     = xc6slx16csg324-2
TOPS	= dma_axi_simple
INCD	= "../../rtl/verilog\
"
#--------------------------------------------------------

all: synthesis

synthesis:
	for T in $(TOPS); do\
		if [ -f $$T.ngc ]; then /bin/rm -f $$T.ngc; fi;\
		(export dev_name=$(DEV);\
		export top_name=$$T;\
		export inc_dir=$(INCD);\
		export design=xst_list.txt;\
		$(XST) -ifn xst_option_ise12_s6.txt -ofn $$T.log;);\
	done

#$(NGCE) -bd angle -w ${T}.ngc ${T}.edif || exit 1;\

clean:
	-@/bin/rm -f compile.log
	-@/bin/rm -f ngc2edif.log
	-@/bin/rm -rf ./xst
	-@/bin/rm -rf ./_xmsgs
	-@/bin/rm -f compile.ngc
	-@/bin/rm -rf xlnx_auto_0_xdb
	-@/bin/rm -f *_xst.xrpt
	-@/bin/rm -f xlnx_auto_0.ise
	-@/bin/rm -f x_list.txt xx_list.txt
	for T in $(TOPS); do\
		/bin/rm -f $$T.xncf;\
		/bin/rm -f $$T.log;\
		/bin/rm -f $$T.edif;\
		/bin/rm -f $$T.ngc;\
		/bin/rm -f $$T.ngr;\
		/bin/rm -f $$T.lso;\
		/bin/rm -f $$T.blc;\
	done

cleanup: clean
	for T in $(TOPS); do\
		/bin/rm -f $$T.edif;\
	done

clobber: cleanup
