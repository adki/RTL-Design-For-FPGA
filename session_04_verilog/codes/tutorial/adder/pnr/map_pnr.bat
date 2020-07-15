REM @echo off

REM  Copyright (c) 2009 by Ando Ki.
REM  All right reserved.
REM  
REM  This code is distributed in the hope that it will
REM  be useful to understand Ando Ki's book,
REM  but WITHOUT ANY WARRANTY.

echo Xilinx Mapping and PAR started at %TIME% on %DATE%

if not defined XILINX (
echo "XILINX should be defined".
exit
) else (
echo "%XILINX% where Xilinx ISE is installed".
)

set TOP=full_adder
set DEV=xc3s1000-fg456-4

echo STEP 1 (ngdbuild)
%XILINX%\bin\nt\ngdbuild.exe -p %DEV%^
                             -sd ../syn^
                             -dd .^
                             %TOP% %TOP%.ngd
if %errorlevel% neq 0 exit

echo STEP 2 (map)
%XILINX%\bin\nt\map.exe -p %DEV%^
                        -o %TOP%.ncd %TOP%.ngd  %TOP%.pcf
if %errorlevel% neq 0 exit

echo STEP 3 (par)
%XILINX%\bin\nt\par.exe -w %TOP%.ncd %TOP%.ncd %TOP%.pcf
if %errorlevel% neq 0 exit

echo Xilinx Mapping and PAR finished at %TIME% on %DATE%
PAUSE
