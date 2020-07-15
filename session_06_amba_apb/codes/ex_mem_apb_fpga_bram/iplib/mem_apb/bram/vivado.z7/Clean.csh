#!/bin/csh -f
set TOPS="bram_32x8KB"

foreach F ( ${TOPS} )
    if ( -d ${F}            ) /bin/rm -fr ${F}
    if ( -e ${F}.edn        ) /bin/rm -f  ${F}.edn
    if ( -e ${F}.gise       ) /bin/rm -f  ${F}.gise
    if ( -e ${F}.ise        ) /bin/rm -f  ${F}.ise
    if ( -e ${F}.veo        ) /bin/rm -f  ${F}.veo
    if ( -e ${F}.xise       ) /bin/rm -f  ${F}.xise
    if ( -e ${F}.xncf       ) /bin/rm -f  ${F}.xncf
    if ( -e ${F}.asy        ) /bin/rm -f  ${F}.asy
    if ( -e ${F}_flist.txt  ) /bin/rm -f  ${F}_flist.txt
    if ( -e ${F}_readme.txt ) /bin/rm -f  ${F}_readme.txt
    if ( -e ${F}_xmdf.tcl   ) /bin/rm -f  ${F}_xmdf.tcl
    if ( -d ${F}_xdb        ) /bin/rm -fr ${F}_xdb
end
if ( -d blk_mem_gen_v3_1_xdb  ) /bin/rm -fr blk_mem_gen_v3_1_xdb
if ( -e blk_mem_gen_ds512.pdf ) /bin/rm -f  blk_mem_gen_ds512.pdf
if ( -e coregen.log           ) /bin/rm -f  coregen.log
if ( -e summary.log           ) /bin/rm -f  summary.log
if ( -e ngc2edif.log          ) /bin/rm -f  ngc2edif.log
if ( -d tmp                   ) /bin/rm -fr tmp
if ( -d _xmsgs                ) /bin/rm -fr _xmsgs
if ( -d xlnx_auto_0_xdb       ) /bin/rm -fr xlnx_auto_0_xdb
if ( -e .lso                  ) /bin/rm -rf .lso
