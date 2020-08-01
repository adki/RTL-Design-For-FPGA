@ECHO OFF

SET WORK=work
SET SIM=my_sim
SET TOP=top

IF EXIST %WORK%         RMDIR /S/Q %WORK%
IF EXIST vlog.log       DEL   /Q   vlog.log
IF EXIST fuse.log       DEL   /Q   fuse.log
IF EXIST isim.log       DEL   /Q   isim.log
IF EXIST wave.vcd       DEL   /Q   wave.vcd
IF EXIST isim.wdb       DEL   /Q   isim.wdb
IF EXIST fds.v          DEL   /Q   fds.v
IF EXIST mm.args        DEL   /Q   mm.args
IF EXIST mx.args        DEL   /Q   mx.args
IF EXIST m.args         DEL   /Q   m.args
IF EXIST xx.txt         DEL   /Q   xx.txt
IF EXIST x.txt          DEL   /Q   x.txt
IF EXIST %TOP%.exe      DEL   /Q   %TOP%.exe
IF EXIST isim           RMDIR /S/Q isim
IF EXIST %SIM%.exe      DEL   /Q   %SIM%.exe
IF EXIST %SIM%.log      DEL   /Q   %SIM%.log
