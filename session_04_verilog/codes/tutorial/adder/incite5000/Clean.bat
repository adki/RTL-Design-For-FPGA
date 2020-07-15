@ECHO OFF

REM  Copyright (c) 2008 by Ando Ki.
REM  All right reserved.
REM
REM  This code is distributed in the hope that it will
REM  be useful to understand Ando Ki's book,
REM  but WITHOUT ANY WARRANTY.

IF EXIST .work         RMDIR /Q/S .work
IF EXIST log           RMDIR /Q/S log
IF EXIST nativec       RMDIR /Q/S nativec
IF EXIST sim           RMDIR /Q/S sim
IF EXIST syn           RMDIR /Q/S syn
IF EXIST systemc       RMDIR /Q/S systemc
IF EXIST sim_vhdl      RMDIR /Q/S sim_vhdl
IF EXIST par_edif      RMDIR /Q/S par_edif
IF EXIST par\fpga0.eif COPY par\fpga0.eif fpga0.eif >NUL
IF EXIST par\fpga0_trsim.eif COPY par\fpga0_trsim.eif fpga0_trsim.eif >NUL
IF EXIST par           (
	PUSHD par
	DEL   /Q   *.* >NUL
	IF EXIST xlnx_auto_0_xdb RMDIR /Q/S xlnx_auto_0_xdb
	POPD
)
IF EXIST par           MOVE fpga0.eif par\fpga0.eif >NUL
IF EXIST par           MOVE fpga0_trsim.eif par\fpga0_trsim.eif >NUL
REM IF EXIST *.bak         DEL   /Q *.bak
REM IF EXIST rtl_wiz       RMDIR /Q/S rtl_wiz
