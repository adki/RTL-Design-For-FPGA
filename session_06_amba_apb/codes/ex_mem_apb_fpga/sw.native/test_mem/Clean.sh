#!/bin/sh

PROG="test"

if [ -f ${PROG}.exe  ]; then /bin/rm -f  ${PROG}.exe ; fi
if [ -f ${PROG}.elf  ]; then /bin/rm -f  ${PROG}.elf ; fi
if [ -f ${PROG}.bin  ]; then /bin/rm -f  ${PROG}.bin ; fi
if [ -f ${PROG}.hex  ]; then /bin/rm -f  ${PROG}.hex ; fi
if [ -f ${PROG}.hexa ]; then /bin/rm -f  ${PROG}.hexa; fi
if [ -f ${PROG}.o    ]; then /bin/rm -f  ${PROG}.o   ; fi
if [ -f ${PROG}.map  ]; then /bin/rm -f  ${PROG}.map ; fi
if [ -f ${PROG}.sym  ]; then /bin/rm -f  ${PROG}.sym ; fi
if [ -d obj          ]; then /bin/rm -fr obj         ; fi

/bin/rm -f *.o
