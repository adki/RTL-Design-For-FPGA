SHELL		= /bin/sh
MAKEFILE	= Makefile

#--------------------------------------------------------
all:
	impact -batch impact.cmd

#--------------------------------------------------------
clean:
	-@/bin/rm -f  _impactbatch.log
	-@/bin/rm -f  impact.exe_log.log
	-@/bin/rm -f  _impact.log
	-@/bin/rm -f  _impact.cmd

cleanup: clean

clobber: cleanup

cleanupall: cleanup
