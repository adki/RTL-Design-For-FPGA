#
# Copyright (c) 2009 by Ando Ki.
# All right reserved.
# 
# This code is distributed in the hope that it will
# be useful to understand Ando Ki's book,
# but WITHOUT ANY WARRANTY.
#

DIRS	= upward scope parameter

all:

clean cleanup clobber:
	for D in $(DIRS); do\
		if [ -d $$D ] ; then \
			if [ -f $$D/Makefile ] ; then \
				(cd $$D && make -s $@);\
			fi\
		fi;\
	done
