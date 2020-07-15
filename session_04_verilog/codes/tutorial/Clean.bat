@ECHO OFF

REM  Copyright (c) 2009 by Ando Ki.
REM  All right reserved.
REM
REM  This code is distributed in the hope that it will
REM  be useful to understand Ando Ki's book,
REM  but WITHOUT ANY WARRANTY.

@SET DIRS=hello adder

@FOR %%d IN ( %DIRS% ) DO @(
	@IF EXIST %%d\Clean.bat (
		@PUSHD %%d
		@CALL .\Clean.bat
                @POPD
	)
)
