@ECHO OFF
::----------------------------------------------------------------
:: Copyright (c) 2013 by Ando Ki.
:: All right reserved.
::
:: This code is distributed in the hope that it will
:: be useful to understand Ando Ki's book,
:: but WITHOUT ANY WARRANTY.
::----------------------------------------------------------------
SET WORK=work
SET VLOG=vlogcomp
SET FUSE=fuse
SET SIM=my_sim
SET DESIGNTOP=top
::----------------------------------------------------------------
IF NOT "%1" == "" (
   IF "%1" == "COM" GOTO COMPILE
   IF "%1" == "ELA" GOTO ELABORATION
   IF "%1" == "SIM" GOTO SIMUL
   ECHO "Usage: RunMe.bat [COM | ELA | SIM]"
   GOTO CLRX
)
::----------------------------------------------------------------
:COMPILE
3F EXIST %WORK% RMDIR /S/Q %WORK%
%VLOG% --work %WORK% -f isim.args
IF %errorlevel% NEQ 0 GOTO END
IF NOT "%1" == "" GOTO CLRX
::----------------------------------------------------------------
:ELABORATION
%FUSE% -o %SIM%.exe %WORK%.%DESIGNTOP%^
       -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver
IF %errorlevel% NEQ 0 GOTO END
IF NOT "%1" == "" GOTO CLRX
::----------------------------------------------------------------
:SIMUL
.\%SIM%.exe -tclbatch isim.tcl -log %SIM%.log
IF %errorlevel% NEQ 0 GOTO CLRX
::----------------------------------------------------------------
:CLRX
IF EXIST mc.args DEL /Q mc.args
IF EXIST mm.args DEL /Q mm.args
IF EXIST mx.args DEL /Q mx.args
IF EXIST m.args  DEL /Q m.args
IF EXIST xx.txt  DEL /Q xx.txt 
IF EXIST x.txt   DEL /Q x.txt 
::----------------------------------------------------------------
:END
PAUSE
