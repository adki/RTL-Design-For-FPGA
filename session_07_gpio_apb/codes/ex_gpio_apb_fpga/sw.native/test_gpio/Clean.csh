#!/bin/csh -f

set PROG="test"

if ( -e ${PROG}.exe  ) rm -f  ${PROG}.exe 
if ( -e ${PROG}.elf  ) rm -f  ${PROG}.elf 
if ( -e ${PROG}.bin  ) rm -f  ${PROG}.bin 
if ( -e ${PROG}.hex  ) rm -f  ${PROG}.hex 
if ( -e ${PROG}.hexa ) rm -f  ${PROG}.hexa
if ( -e ${PROG}.o    ) rm -f  ${PROG}.o   
if ( -e ${PROG}.map  ) rm -f  ${PROG}.map 
if ( -e ${PROG}.sym  ) rm -f  ${PROG}.sym 
if ( -e obj          ) rm -fr obj         

/bin/rm -f *.o
