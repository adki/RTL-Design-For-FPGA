vlib work
vlog ../design/top.v
vlog ../design/stimulus.v
vlog ../design/full_adder_ref.v
vlog ../design/checker.v
vlog ../syn/full_adder_gate.v^
     +libext+.v -y %XILINX%/verilog/src/simprims^
                -y %XILINX%/verilog/src/unisims
vsim -c -do "run -all; quit" work.top work.glbl
PAUSE
