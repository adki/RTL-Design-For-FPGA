#!/bin/sh -f
# Copyright (c) 2009 by Ando Ki.
# All right reserved.
#
# This code is distributed in the hope that it will
# be useful to understand iPROVE related products,
# but WITHOUT ANY WARRANTY.

VLIB=`which vlib`
VLOG=`which vlog`
VSIM=`which vsim`

${VLIB} work
${VLOG} -work work -lint -f modelsim.args
${VSIM} -c -do "run -all; quit" work.top
