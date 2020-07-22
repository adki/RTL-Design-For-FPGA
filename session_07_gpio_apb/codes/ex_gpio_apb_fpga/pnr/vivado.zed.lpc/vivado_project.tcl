if {[info exists env(VIVADO_VER)] == 0} {
     set VIVADO_VER vivado.2018.3
} else {
     set VIVADO_VER $::env(VIVADO_VER)
}
if {[info exists env(CONFMC_HOME)] == 0} {
     set CONFMC_HOME /opt/confmc/2020.06
} else {
     set CONFMC_HOME $::env(CONFMC_HOME)
}
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
     set FPGA_TYPE  z7
} else {
     set FPGA_TYPE $::env(FPGA_TYPE)
}
if {[info exists env(BOARD_TYPE)] == 0} {
     set BOARD_TYPE BOARD_ZED
} else {
     set BOARD_TYPE $::env(BOARD_TYPE)
}
if {[info exists env(FIP_HOME)] == 0} {
     set FIP_HOME ../../iplib
} else {
     set FIP_HOME $::env(FIP_HOME)
}
if {[info exists env(DIR_DESIGN)] == 0} {
     set DIR_DESIGN "../../design/verilog"
} else {
     set DIR_DESIGN $::env(DIR_DESIGN)
}
if {[info exists env(DIR_XDC)] == 0} {
     set DIR_XDC "xdc"
} else {
     set DIR_XDC $::env(DIR_XDC)
}
if {[info exists env(TOP_MODULE)] == 0} { 
     set TOP_MODULE fpga
} else { 
     set TOP_MODULE $::env(TOP_MODULE)
}
if {[info exists env(EDIF)] == 0} {
     set EDIF fpga.edn
} else {
     set EDIF $::env(EDIF)
}
if {[info exists env(XDC_ILA)] == 0} { 
     set XDC_ILA 0
} else { 
     set XDC_ILA $::env(XDC_ILA)
}
if {[info exists env(XDC_TARGET)] == 0} { 
     set XDC_TARGET target.xdc
} else { 
     set XDC_TARGET $::env(XDC_TARGET)
}
if {[info exists env(WORK)] == 0} { 
     set WORK work
} else { 
     set WORK $::env(WORK)
}
if {[info exists env(RIGOR)] == 0} {
     set RIGOR 0
} else {
     set RIGOR $::env(RIGOR)
}
if {[info exists env(GUI)] == 0} {
     set GUI 0
} else {
     set GUI $::env(GUI)
}
if {[info exists env(SYN_ONLY)]==0} {
     set SYN_ONLY     0
} else {
     set SYN_ONLY     $::env(SYN_ONLY)
}
if {[info exists env(ILA)] == 0} {
     set ILA 0
} else {
     set ILA $::env(ILA)
}
if { ${ILA} == 1} {
   if {[info exists env(BIT)] == 0} {
        set BIT fpga_ila.bit
   } else {
        set BIT $::env(BIT)
   }
} else {
   if {[info exists env(BIT)] == 0} {
        set BIT fpga.bit
   } else {
        set BIT $::env(BIT)
   }
}

#=====================================================================
if {[file exists ${PROJECT_DIR}] == 1} {
       puts "Project sub-dirctory exists: ${PROJECT_DIR}\n"
       open_project ${PROJECT_DIR}/${PROJECT_NAME}.xpr
} else {
       puts "Project sub-dirctory create: ${PROJECT_NAME}\n"
       create_project -force -part ${DEVICE} ${PROJECT_NAME} ${PROJECT_DIR}
}

#=====================================================================
proc number_of_processor {} {
    global tcl_platform env
    switch ${tcl_platform(platform)} {
        "windows" {
            return $env(NUMBER_OF_PROCESSORS)
        }

        "unix" {
            if {![catch {open "/proc/cpuinfo"} f]} {
                set cores [regexp -all -line {^processor\s} [read $f]]
                close $f
                if {$cores > 0} {
                    return $cores
                }
            }
        }

        "Darwin" {
            if {![catch {exec {*}$sysctl -n "hw.ncpu"} cores]} {
                return $cores
            }
        }

        default {
            puts "Unknown System"
            return 1
        }
    }
}
set NPROC [expr int([number_of_processor])]
if { ${NPROC}>=8 } {
   set_param general.maxThreads [expr int(${NPROC}/2)]
} else {
   set_param general.maxThreads ${NPROC}
}
puts "num_of_processor=[number_of_processor]"
puts "num_of_thread=[get_param general.MaxThreads]"

#=====================================================================
 set DIR_CURRENT       "."
 set DIR_DESIGN        "../../design/verilog"
 set DIR_BFM_AXI       "${CONFMC_HOME}/hwlib/trx_axi"
 set DIR_BFM_APB       "${FIP_HOME}/bfm_apb/rtl/verilog"
 set DIR_GPIO          "../../../ex_gpio_apb/rtl/verilog"
 set DIR_BEH           "../../beh/verilog"
 set DIR_BENCH         "../../bench/verilog"

#=====================================================================
set VERILOG_DIR_LIST "${DIR_CURRENT}
                      ${DIR_DESIGN}
                      ${DIR_BFM_AXI}
                      ${DIR_BFM_APB}
                      ${DIR_GPIO}
                      ${DIR_BEH}
                      ${DIR_BENCH}"
set_property verilog_dir ${VERILOG_DIR_LIST} [current_fileset]

read_edif "${DIR_BFM_AXI}/syn/vivado.${FPGA_TYPE}/bfm_axi.edif"
add_files "${DIR_DESIGN}/defines_system.v
           ${DIR_DESIGN}/fpga.v
           ${DIR_BFM_AXI}/rtl/verilog/bfm_axi_stub.v
           ${DIR_BFM_APB}/bfm_apb_s4.v
           ${DIR_GPIO}/gpio_apb.v
          "

#=====================================================================
#add_files -fileset sim_1 ${DIR_BENCH}/top.v

#=====================================================================
add_files -fileset constrs_1 "${DIR_XDC}/fpga_etc.xdc
                              ${DIR_XDC}/fpga_zed.xdc
                              ${DIR_XDC}/con-fmc_lpc_zed.xdc"

set fid [ open ${XDC_TARGET} w+ ]
close $fid
set_property target_constrs_file ${XDC_TARGET} [current_fileset -constrset]

#=====================================================================
# macros
set VERILOG_DEFINE_LIST " SYN=1
                          VIVADO=1
                          ${FPGA_TYPE}=1
                          ${BOARD_TYPE}=1
                          AMBA_AXI4=1
                          AMBA_APB4=1
                          AMBA_APB3=1
                        "
set_property verilog_define ${VERILOG_DEFINE_LIST} [current_fileset]

#=====================================================================
set_property is_global_include true [get_files  ${DIR_DESIGN}/defines_system.v]
#=====================================================================
# Manual Compile Order mode
set_property source_mgmt_mode None [current_project]
set_property top_file ${DIR_DESIGN}/fpga.v [current_fileset]
reorder_files -fileset [current_fileset] -front ${DIR_DESIGN}/defines_system.v
reorder_files -fileset [current_fileset] -after ${DIR_DESIGN}/defines_system.v ${DIR_DESIGN}/fpga.v

#=====================================================================
set_property top ${TOP_MODULE} [current_fileset]
update_compile_order -fileset sources_1
#get_files -compile_order sources -used_in synthesis
#update_compile_order -fileset sim_1
#get_files -compile_order sources -used_in simulation

#=====================================================================
if { ${ILA} == 0 } {
    launch_runs synth_1
    wait_on_run synth_1
    if { ${SYN_ONLY} == 0 } {
        set_property STEPS.OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
        set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
        set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
        set_property STEPS.PLACE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
        set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
        set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
        launch_runs impl_1 -to_step write_bitstream
        wait_on_run impl_1
        puts "Implementation done!"
        open_run impl_1
        write_bitstream -force ${BIT}
    }
}

if { ${GUI} == 0 } {
    exit
}

#=====================================================================
# https://grittyengineer.com/vivado-project-mode-tcl-script/
#########################################################################
