REM @ECHO OFF

SET IMPACT=impact.exe
SET FLOG=%IMPACT%_log.log
SET SBIT=fpga.bit

ECHO "%IMPACT% -batch impact.cmd"
ECHO "%IMPACT% -batch impact.cmd" >> %FLOG% 2>&1
%IMPACT% -batch impact.cmd >> %FLOG% 2>&1
IF %errorlevel% NEQ 0 (
   ECHO Error occured while running impact, see %FLOG%.
)

:END
PAUSE
