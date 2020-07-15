vlib work
vlog top.v
vlog mem_generic.v
vsim -c -do "run -all; quit" work.top
PAUSE
