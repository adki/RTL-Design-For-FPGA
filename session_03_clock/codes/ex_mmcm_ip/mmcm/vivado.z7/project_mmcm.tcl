#-----------------------------------------------------------
if {[info exists env(DEVICE)] == 0} { 
     set DEVICE xc7z020clg484-1
} else {
     set DEVICE $::env(DEVICE)
}
if {[info exists env(MODULE)] == 0} { 
     set MODULE clk_wizard
} else { 
     set MODULE $::env(MODULE)
}
if {[info exists env(DEPTH)] == 0} { 
     set DEPTH 8
} else { 
     set DEPTH $::env(DEPTH)
}

set_part ${DEVICE}
#-----------------------------------------------------------
create_project managed_ip_project managed_ip_project -part ${DEVICE} -ip -force
set_property simulator_language Verilog [current_project]
set_property target_simulator Questa [current_project]
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0\
          -module_name ${MODULE}\
          -dir [pwd] -force
set_property -dict [list CONFIG.PRIM_IN_FREQ {100.000}\
                         CONFIG.NUM_OUT_CLKS {2}\
                         CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.000}\
                         CONFIG.CLKOUT1_REQUESTED_DUTY_CYCLE {50.000}\
                         CONFIG.CLKOUT2_USED {true}\
                         CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {80.000}\
                         CONFIG.CLKOUT2_REQUESTED_DUTY_CYCLE {50.000}\
                         CONFIG.MMCM_CLKFBOUT_MULT_F {8.000}\
                         CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000}\
                         CONFIG.MMCM_CLKOUT1_DIVIDE {10}\
                         CONFIG.CLKOUT1_JITTER {144.719}\
                         CONFIG.CLKOUT1_PHASE_ERROR {114.212}\
                         CONFIG.CLKOUT2_JITTER {151.652}\
                         CONFIG.CLKOUT2_PHASE_ERROR {114.212}\
                   ] [get_ips ${MODULE}]
generate_target {instantiation_template} [get_files ${MODULE}.xci]
generate_target all [get_files  ${MODULE}.xci]
export_ip_user_files -of_objects [get_files ${MODULE}.xci] -no_script -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] ${MODULE}.xci]
launch_run -jobs 4 ${MODULE}_synth_1
wait_on_run ${MODULE}_synth_1
export_simulation -of_objects [get_files ${MODULE}/${MODULE}.xci]\
                  -directory ip_user_files/sim_scripts -force -quiet

if { $::env(GUI) == 0} { 
     exit
}
