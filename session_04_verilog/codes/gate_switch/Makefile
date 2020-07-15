#
# Copyright (c) 2009 by Ando Ki.
# All right reserved.
# 
# This code is distributed in the hope that it will
# be useful to understand Ando Ki's book,
# but WITHOUT ANY WARRANTY.
#

DIRS	= gate_delay buf_delay dff_gate inverter_switch\
	inverter_pull buf_pull charge_decay\
	udp_mux udp_ff udp_dff\
	full_adder_switch_udp

all:

clean cleanup clobber:
	for D in $(DIRS); do\
		if [ -d $$D ] ; then \
			if [ -f $$D/Makefile ] ; then \
				(cd $$D && make -s $@);\
			fi\
		fi;\
	done
