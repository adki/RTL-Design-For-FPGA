vlib work
vlog ../design/top.v
vlog ../design/full_adder.v
vlog ../design/half_adder_gate.v
vlog ../design/half_adder_rtl.v
vlog ../design/stimulus.v
vlog ../design/full_adder_ref.v
vlog ../design/checker.v
vsim -c -do "run -all; quit" work.top
PAUSE
