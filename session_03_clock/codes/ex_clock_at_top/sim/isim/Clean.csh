#!/bin/csh -f

if ( -d work       ) \rm -rf work    
if ( -d isim       ) \rm -rf isim
if ( -e vlog.log   ) \rm -f  vlog.log
if ( -e fuse.log   ) \rm -f  fuse.log
if ( -e isim.log   ) \rm -f  isim.log
if ( -e wave.vcd   ) \rm -f  wave.vcd
if ( -e isim.wdb   ) \rm -f  isim.wdb
if ( -e fds.v      ) \rm -f  fds.v
if ( -e top.exe    ) \rm -f  top.exe
if ( -e my_sim.exe ) \rm -f  my_sim.exe
if ( -e my_sim.log ) \rm -f  my_sim.log
