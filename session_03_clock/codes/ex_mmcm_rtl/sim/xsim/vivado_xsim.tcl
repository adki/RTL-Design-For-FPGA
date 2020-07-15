if {[info exists env(VIVADO_VERSION)] == 0} {
     set VIVADO_VERSION vivado.2018.3
} else {
     set VIVADO_VERSION $::env(VIVADO_VERSION)
}
if {[info exists env(FPGA_TYPE)]==0} {
   set FPGA_TYPE zusp
} else {
   set FPGA_TYPE $::env(FPGA_TYPE)
}
if {[info exists env(TOP)]==0} {
   set TOP top
} else {
   set TOP $::env(TOP)
}
if {[info exists env(DIR_FIP)]==0} {
   set DIR_FIP ../../..
} else {
   set DIR_FIP $::env(DIR_FIP)
}
if {[info exists env(GUI)]==0} {
   set GUI 0
} else {
   set GUI $::env(GUI)
}
#------------------------------------------------------------------
xelab -prj xsim.prj -debug typical\
		-L secureip -L unisims_ver -L unimacro_ver\
		${TOP} glbl -s ${TOP}
#$(eval UU:=$(shell grep "undeclared symbol" xelab.log | wc -l))
#@if [ ${UU} != 0 ]; then echo "ERROR undeclared symbol";\
#else echo "OK"; fi

#------------------------------------------------------------------
if { ${GUI} == 0} {
   xsim ${TOP} -t xsim_run.tcl; fi
} else {
   xsim top -gui;\
}

#------------------------------------------------------------------
if { ${GUI} == 0} {
     exit
}
#------------------------------------------------------------------
