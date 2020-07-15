`ifndef SIM_DEFINE_V
`define SIM_DEFINE_V
//-----------------------------------------------------------------------
//`define SIM      // define this for simulation case if you are not sure
`undef  SYN      // undefine this for simulation case
`define VCD      // define this for VCD waveform dump
`define DEBUG
`define RIGOR
//-----------------------------------------------------------------------
`define XILINX
//-----------------------------------------------------------------------
// define board type: ML605, ZC706, SP605, VCU108
`undef  BOARD_SP605
`undef  BOARD_ML605
`undef  BOARD_VCU108
`undef  BOARD_ZC706
`undef  BOARD_ZC702
`define BOARD_ZED
`undef  BOARD_ZCU111

`ifdef  BOARD_ML605
`define FPGA_FAMILY     "VIRTEX6"
`define ISE
`elsif  BOARD_SP605
`define FPGA_FAMILY     "SPARTAN6"
`define ISE
`elsif  BOARD_VCU108
`define FPGA_FAMILY     "VirtexUS"
`define VIVADO
`elsif  BOARD_ZC706
`define FPGA_FAMILY     "ZYNQ7000"
`define VIVADO
`elsif  BOARD_ZC702
`define FPGA_FAMILY     "ZYNQ7000"
`define VIVADO
`elsif  BOARD_ZED
`define FPGA_FAMILY     "ZYNQ7000"
`define VIVADO
`elsif  BOARD_ZCU111
`define FPGA_FAMILY     "ZynqUSP"
`define VIVADO
`else
`define FPGA_FAMILY     "ARTIX7"
`define ISE
`endif
//-----------------------------------------------------------------------
`define AMBA_AXI4
`define AMBA_APB3
`define AMBA_APB4
//-----------------------------------------------------------------------
// Test case sel
`define TEST_INFO           0
`define TEST_GPIN_OUT       0
`define TEST_SINGLE0        1
`define TEST_BURST1         0
`define TEST_BURST4         0
`define TEST_BURST8         0
`define TEST_BURST16        0
`define TEST_BURST_ALL      0
`define TEST_BURST_LONG     0
`define TEST_ADD_RAW        1
`define TEST_ADD_RAWA       1
//-----------------------------------------------------------------------
`endif
