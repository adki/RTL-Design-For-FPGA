#!/bin/bash

TOPS="bram_32x8KB"

for F in ${TOPS}; do
    if [[ -d ${F}            ]]; then /bin/rm -fr ${F}; fi
    if [[ -f ${F}.edn        ]]; then /bin/rm -f  ${F}.edn ; fi
    if [[ -f ${F}.gise       ]]; then /bin/rm -f  ${F}.gise ; fi
    if [[ -f ${F}.ise        ]]; then /bin/rm -f  ${F}.ise ; fi
    if [[ -f ${F}.veo        ]]; then /bin/rm -f  ${F}.veo ; fi
    if [[ -f ${F}.xise       ]]; then /bin/rm -f  ${F}.xise ; fi
    if [[ -f ${F}.xncf       ]]; then /bin/rm -f  ${F}.xncf ; fi
    if [[ -f ${F}.asy        ]]; then /bin/rm -f  ${F}.asy ; fi
    if [[ -f ${F}_flist.txt  ]]; then /bin/rm -f  ${F}_flist.txt ; fi
    if [[ -f ${F}_readme.txt ]]; then /bin/rm -f  ${F}_readme.txt ; fi
    if [[ -f ${F}_xmdf.tcl   ]]; then /bin/rm -f  ${F}_xmdf.tcl ; fi  
    if [[ -d ${F}_xdb        ]]; then /bin/rm -fr ${F}_xdb ; fi
done

if [ -f coregen.cgc           ]; then /bin/rm -f  coregen.cgc ; fi
if [ -f coregen.log           ]; then /bin/rm -f  coregen.log ; fi
if [ -f ngc2edif.log          ]; then /bin/rm -f  ngc2edif.log ; fi
if [ -d tmp                   ]; then /bin/rm -fr tmp ; fi
if [ -d _xmsgs                ]; then /bin/rm -fr _xmsgs ; fi
if [ -d xlnx_auto_0_xdb       ]; then /bin/rm -fr xlnx_auto_0_xdb; fi
if [ -f .lso                  ]; then /bin/rm -rf .lso; fi
if [ -f xil_*.in              ]; then /bin/rm -f  xil_*.in; fi
if [ -f xil_*.out             ]; then /bin/rm -f  xil_*.out; fi
if [ -f get_initp_pfile.tmp   ]; then /bin/rm -f  get_initp_pfile.tmp; fi
if [ -f summary.log           ]; then /bin/rm -f  summary.log; fi
