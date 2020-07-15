@echo off

REM  Copyright (c) 2009 by Ando Ki.
REM  All right reserved.
REM  
REM  This code is distributed in the hope that it will
REM  be useful to understand Ando Ki's book,
REM  but WITHOUT ANY WARRANTY.

set device_target=xc3s1000-fg456-4
set inc_dir="../design"
set top_target=full_adder
set design=xst_list.xst
if exist %top_target%.ngc del %top_target%.ngc
xst -ifn xst_option.xst -ofn %top_target%.log 
ngc2edif -bd angle -w %top_target%.ngc %top_target%.edif
netgen -w -ofmt verilog %top_target%.ngc %top_target%_gate.v
REM copy %top_target%.edif ..\%top_target%.edif

pause
