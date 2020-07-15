@echo off

DEL   /Q    _eifgen.log
DEL   /Q    fpga0.eif
DEL   /Q    fpga1.eif
DEL   /Q    fpga2.eif
DEL   /Q    fpga3.eif
DEL   /Q    fpga.mit
DEL   /Q    fpga.rbt
DEL   /Q    fpga.tcf
DEL   /Q    _rbt2tcf.log
DEL   /Q    vivado_20734.backup.jou
DEL   /Q    vivado_20734.backup.log
DEL   /Q    vivado.jou
DEL   /Q    vivado.log
RMDIR /S/Q  work
RMDIR /S/Q  .Xil
