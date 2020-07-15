@ECHO OFF

REM  Copyright (c) 2008 by Ando Ki.
REM  All right reserved.
REM  
REM  This code is distributed in the hope that it will
REM  be useful to understand Ando Ki's book,
REM  but WITHOUT ANY WARRANTY.

set TOP=full_adder

if exist *.ngc        del /Q *.ngc
if exist *.log        del /Q *.log
if exist *.edif       del /Q *.edif
if exist *.xncf       del /Q *.xncf
if exist *.lso        del /Q *.lso 
if exist *.nlf        del /Q *.nlf
if exist xst          rmdir /S/Q xst
if exist xlnx_auto_0_xdb rmdir /S/Q xlnx_auto_0_xdb
if exist *_xst.xrpt      del /Q *_xst.xrpt
if exist xlnx_auto_0.ise del /Q xlnx_auto_0.ise
if exist %TOP%_gate.v    del /Q %TOP%_gate.v
if exist %TOP%_gate.nlf  del /Q %TOP%_gate.nlf
if exist %TOP%.bld  del /Q %TOP%.bld
if exist netlist.lst del /Q netlist.lst
