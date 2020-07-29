#-------------------------------------------------------------------
# Copyright (c) 2013 by Ando Ki.
# All right reserved.
# 
# This code is distributed in the hope that it will
# be useful to understand Ando Ki's work,
# but WITHOUT ANY WARRANTY.
#-------------------------------------------------------------------
SHELL		= /bin/sh
MAKEFILE	= Makefile
#--------------------------------------------------------
XST	= $(shell which xst)
NGCB	= $(shell which ngcbuild)
NGCE	= $(shell which ngc2edif)
WORK	= work
DEV	= xc3s5000-fg900-4
INCD	= "../../rtl/verilog\
          "
#--------------------------------------------------------
TOPS	= dma_axi_simple
#--------------------------------------------------------
all: synthesis

synthesis:
	for T in $(TOPS); do\
		if [ -d xst ]; then /bin/rm -rf xst; fi;\
		if [ -f $$T.ngc ]; then /bin/rm -f $$T.ngc; fi;\
		(export dev_name=$(DEV);\
		export top_name=$$T;\
		export inc_dir=$(INCD);\
		export design=xst_list.txt;\
		$(XST) -ifn xst_option.txt -ofn $$T.log;);\
	done

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
	-@/bin/rm -f fifo32x1024.ngo
	-@/bin/rm -f fifo32x512.ngo
	-@/bin/rm -f hif.ngo
	-@/bin/rm -f usbhif8core.ngo
	for T in $(TOPS); do\
		/bin/rm -f $$T.xncf;\
		/bin/rm -f $$T.log;\
		/bin/rm -f $$T.lso;\
		/bin/rm -f $$T.blc;\
		/bin/rm -f $$T.ngc;\
		/bin/rm -f $$T.edif;\
	done

cleanup: clean
	-@/bin/rm -f rtc.ngc

clobber: cleanup
