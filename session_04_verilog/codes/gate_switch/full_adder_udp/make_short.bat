@ECHO OFF
REM make_short.bat
vlib work
vlog ./top.v
vlog ./stimulus.v
vlog ./checker.v
vlog ./full_adder.v
vsim -c -do "run -all; finish" work.top
pause
