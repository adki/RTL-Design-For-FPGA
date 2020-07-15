vlib work
vlog top.v
vlog stimulus.v
vlog checker.v
vlog full_adder_ref.v
vlog full_adder.v
vlog half_adder_udp.v
vlog half_adder_switch.v
vsim -c -do "run -all; quit" work.top
PAUSE
