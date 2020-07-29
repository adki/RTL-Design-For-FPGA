#!/bin/csh -f
if ( -d xst             ) \rm -rf xst
if ( -d _xmsgs          ) \rm -rf _xmsgs
if ( -e compile.log     ) \rm -f compile.log
if ( -e ngc2edif.log    ) \rm -f ngc2edif.log
if ( -e compile.ngc     ) \rm -f compile.ngc
if ( -e xilinx.log      ) \rm -f xilinx.edif
if ( -d xlnx_auto_0_xdb ) \rm -rf xlnx_auto_0_xdb
if ( -e xlnx_auto_0.ise ) \rm -f xlnx_auto_0.ise
if ( -e x_list.txt      ) \rm -f x_list.txt
if ( -e xx_list.txt     ) \rm -f xx_list.txt
\rm -f *.xncf
\rm -f *.lso
\rm -f *.ngr
\rm -f *.ngc
\rm -f *.edif
\rm -f *.log
\rm -f *.blc
\rm -f *.xrpt
if ( -e fifo32x1024.ngo ) \rm -f  fifo32x1024.ngo
if ( -e fifo32x512.ngo  ) \rm -f  fifo32x512.ngo 
if ( -e hif.ngo         ) \rm -f  hif.ngo        
if ( -e usbhif8core.ngo ) \rm -f  usbhif8core.ngo
