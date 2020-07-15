`ifndef DEFINES_SYSTEM_V
`define DEFINES_SYSTEM_V
//------------------------------------------------------------------------------
// Copyright (c) 2018 by Future Design Systems Co., Ltd.
// All right reserved
//
// http://www.future-ds.com
//------------------------------------------------------------------------------
// defines_system.v
//------------------------------------------------------------------------------
// VERSION: 2018.02.05.
//------------------------------------------------------------------------------
// define board type: ML605 SP605 VCU108
//`define BOARD_ML605
//`define BOARD_SP605
//`define BOARD_VCU108

//------------------------------------------------------------------------------
`ifdef SIM
`include "sim_define.v"
`elsif SYN
`include "syn_define.v"
`endif

//------------------------------------------------------------------------------
// Revision history:
//
// 2018.02.05: Prepared by Ando Ki (adki@future-ds.com)
//------------------------------------------------------------------------------
`endif
