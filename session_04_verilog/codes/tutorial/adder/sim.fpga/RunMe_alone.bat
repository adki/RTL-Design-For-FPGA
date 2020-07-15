vlib work
vlog ../design/top.v +define+iNCITE
vlog ../incite5000/sim_verilog/full_adder_proxy.v
vlog ../design/stimulus.v
vlog ../design/full_adder_ref.v
vlog ../design/checker.v
vsim -c -do "run -all; quit" work.top
PAUSE
