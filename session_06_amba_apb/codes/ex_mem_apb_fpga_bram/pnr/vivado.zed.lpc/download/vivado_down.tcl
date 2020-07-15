#
# NOTE:  typical usage would be "vivado -mode tcl -source run.tcl" 

#########################################################################
# Define output directory area.
#########################################################################
puts $::env(XILINX_VIVADO)
puts $::env(BITFILE)

#########################################################################
open_hw
connect_hw_server
open_hw_target
current_hw_device [get_hw_devices xc7z020_1]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7z020_1] 0]
set_property PROBES.FILE {} [get_hw_devices xc7z020_1]
set_property FULL_PROBES.FILE {} [get_hw_devices xc7z020_1]
set_property PROGRAM.FILE "$::env(BITFILE)" [get_hw_devices xc7z020_1]
program_hw_devices [get_hw_devices xc7z020_1]
refresh_hw_device [lindex [get_hw_devices xc7z020_1] 0]
#########################################################################
