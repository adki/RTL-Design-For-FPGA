REM @ECHO off
ECHO *****************************************
ECHO Synthesis using XST.
ECHO Copyright (c) 2011 Future Design Systems
ECHO *****************************************

SET dev_name=xc6slx16csg324-2
SET top_name=dma_axi_simple
SET inc_dir={ "../../rtl/verilog"^
}

SET design=xst_list.txt

IF EXIST %top_name%.ngc DEL %top_name%.ngc
xst -ifn xst_option_ise12_s6.txt -ofn %top_name%.log 
IF %errorlevel% NEQ 0 GOTO END
IF NOT EXIST %top_name%.ngc (
   ECHO %top_name%.ngc not found.
   GOTO END
)

:END
pause
