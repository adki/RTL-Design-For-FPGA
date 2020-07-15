@ECHO OFF
REM Copyright (c) 2009 by Ando Ki.
REM All right reserved.
REM
REM This code is distributed in the hope that it will
REM be useful to understand iPROVE related products,
REM but WITHOUT ANY WARRANTY.

SET MODELSIMWORK=work
SET MODELSIMVLIB=vlib
SET MODELSIMVSIM=vsim
SET MODELSIMVCOM=vcom
SET MODELSIMVLOG=vlog

SET DESIGNTOP=%MODELSIMWORK%.top

%MODELSIMVLIB% %MODELSIMWORK%
%MODELSIMVLOG% -work %MODELSIMWORK% -f modelsim.args
%MODELSIMVSIM% -c -do "run -all; quit" %DESIGNTOP%
PAUSE
