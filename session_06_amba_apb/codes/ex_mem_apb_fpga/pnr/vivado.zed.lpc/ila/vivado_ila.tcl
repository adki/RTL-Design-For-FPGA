# NOTE:  typical usage would be "vivado -mode tcl -source run.tcl" 
#########################################################################
# Define output directory area.
#########################################################################

if {[info exists env(PROJECR_DIR)] == 0} {
     set PROJECT_DIR project_1
} else {
     set PROJECT_DIR $::env(PROJECT_DIR)
}
if {[info exists env(PROJECR_NAME)] == 0} {
     set PROJECT_NAME project_1
} else { 
     set PROJECT_NAME $::env(PROJECT_NAME)
}
if {[info exists env(DEVICE)] == 0} {
     set DEVICE xc7z020-clg484-1
} else {
     set DEVICE $::env(DEVICE)
}
if {[info exists env(FPGA_TYPE)] == 0} {
     set FPGA_TYPE  ZYNQ7000
     set DEVICE     xc7z020-clg484-1
     set BOARD_TYPE BOARD_ZED
} else {
     set FPGA_TYPE $::env(FPGA_TYPE)
     if {${FPGA_TYPE}=="ZYNQ7000"} {
          set DEVICE     xc7z020-clg484-1
          set BOARD_TYPE BOARD_ZED
     } else {
          puts "${FPGA_TYPE} not supported"
          exit 1
     }
}
if {[info exists env(MODULE)] == 0} { 
     set MODULE fpga
} else { 
     set MODULE $::env(MODULE)
}
if {[info exists env(XDC_ILA)] == 0} { 
     puts "XDC_ILA not defined"
     exit
} else { 
     set XDC_ILA $::env(XDC_ILA)
}
if {[info exists env(WORK)] == 0} { 
     set WORK work
} else { 
     set WORK $::env(WORK)
}

puts ${PROJECT_DIR}
puts ${PROJECT_NAME}
puts ${DEVICE}
puts ${MODULE}

file mkdir ${WORK}
set_part ${DEVICE}


if {[file exists ${PROJECT_DIR}] == 1} {
       puts "Project sub-dirctory exists: ${PROJECT_DIR}\n"
       open_project ${PROJECT_DIR}/${PROJECT_NAME}.xpr
} else {
       puts "Project sub-dirctory create: ${PROJECT_NAME}\n"
       create_project ${PROJECT_NAME} ${PROJECT_DIR} -force -part ${DEVICE}
}

set_property design_mode GateLvl [current_fileset]

add_files -norecurse "../${MODULE}.edn"

import_files -force -norecurse

import_files -fileset constrs_1 -force -norecurse "${XDC_ILA}"
set_property top_file ../${MODULE}.edn [current_fileset]
link_design -top ${MODULE} -part ${DEVICE} -name netlist_1
write_checkpoint -force ${WORK}/Opt_design.dcp

#########################################################################
