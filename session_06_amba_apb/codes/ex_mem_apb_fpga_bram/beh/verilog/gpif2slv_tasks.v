`ifndef GPIF2SLV_TASKS_V
`define GPIF2SLV_TASKS_V
//------------------------------------------------------------------------------
// Copyright (c) 2019 by Future Design Systems.
// All right reserved.
//------------------------------------------------------------------------------
// gpif2slv_tasks.v
//------------------------------------------------------------------------------
// VERSION: 2019.04.10.
//------------------------------------------------------------------------------
// Cypress EZ-USB GPIF-II slave interface slave model.
// - EZ-USB model
//------------------------------------------------------------------------------
reg [31:0] u2f_data[0:4095];
reg [31:0] f2u_data[0:4095];
integer task_seed=1;

//------------------------------------------------------------------------------
// drive SL_RST_N
task gpif2_reset;
begin
     SL_RST_N = 1'b0;
     repeat (3) @ (posedge SL_PCLK);
     SL_RST_N = 1'b1;
end
endtask
//------------------------------------------------------------------------------
// set mode
task gpif2_mode;
     input [1:0] mode;
begin
     SL_RST_N = 1'b0;
     repeat (3) @ (posedge SL_PCLK);
     SL_MODE = mode;
     repeat (3) @ (posedge SL_PCLK);
     SL_RST_N = 1'b1;
     repeat (3) @ (posedge SL_PCLK);
end
endtask
//------------------------------------------------------------------------------
// put control-flit to get information
task gpif2_get_info;
     reg [15:0] length;
     integer idx;
begin
     length = 3;
     @ (posedge SL_PCLK);
     u2f_wr_valid = 1'b1;
     u2f_wr_data  = {length,CMD_REQ,4'h0,4'h0,4'h0};
     @ (posedge SL_PCLK);
     while (u2f_wr_ready==1'b0) @ (posedge SL_PCLK);
     u2f_wr_valid = 1'b0;
     for (idx=0; idx<length; idx=idx+1) begin
          f2u_rd_ready = 1'b1;
          @ (posedge SL_PCLK);
          while (f2u_rd_valid==1'b0) @ (posedge SL_PCLK);
          f2u_data[idx] = f2u_rd_data;
     end // for
     f2u_rd_ready = 1'b0;
end
endtask
//------------------------------------------------------------------------------
// put control-flit to fill CMD-FIFO wihtout random delay
task gpif2_u2f_cmd;
     input [ 3:0] trans ; // TRSNO
     input [15:0] length;
begin
     gpif2_u2f_cmd_core(4'b0010, trans, length, 1'b0);
end
endtask
//------------------------------------------------------------------------------
// put control-flit to fill CMD-FIFO with random delay
task gpif2_u2f_cmd_dly;
     input [ 3:0] trans ; // TRSNO
     input [15:0] length;
begin
     gpif2_u2f_cmd_core(4'b0010, trans, length, 1'b1);
end
endtask
//------------------------------------------------------------------------------
// put control-flit to fill U2F-FIFO without random delay
task gpif2_u2f_dat;
     input [ 3:0] trans ; // TRSNO
     input [15:0] length;
begin
     gpif2_u2f_dat_core(4'b0100, trans, length, 1'b0);
end
endtask
//------------------------------------------------------------------------------
// put control-flit to fill U2F-FIFO with random delay
task gpif2_u2f_dat_dly;
     input [ 3:0] trans ; // TRSNO
     input [15:0] length;
begin
     gpif2_u2f_dat_core(4'b0100, trans, length, 1'b1);
end
endtask
//------------------------------------------------------------------------------
// put control-flit to fill F2U-FIFO without random delay
task gpif2_f2u_dat;
     input [ 3:0] trans ;
     input [15:0] length;
begin
     gpif2_f2u_dat_core(trans, length, 1'b0);
end
endtask
//------------------------------------------------------------------------------
// put control-flit to fill F2U-FIFO with random delay
task gpif2_f2u_dat_dly;
     input [ 3:0] trans ;
     input [15:0] length;
begin
     gpif2_f2u_dat_core(trans, length, 1'b1);
end
endtask
//------------------------------------------------------------------------------
//              31      27      23      19      15      11       7       3     0
//              +-------------------------------+-------------------------------+
//              | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
//              +-------------------------------+-------+-------+-------+-------+
//
//              +-------------------------------+-------+-------+-------+-------+
// cmd-pkt      |         LENG (num of words)   |0 0 1 0|       |TRSNO  |       |
// (come from   +-------------------------------+-------+-------+-------+-------+
//  thread0     | <data 1> (if LENG is 0, there is no data)                     |
//  push        +---------------------------------------------------------------+
//  FIFO_CU2F)  | <data 2>                                                      |
//              +---------------------------------------------------------------+
//              |  .....                                                        |
//              +---------------------------------------------------------------+
//              | <data LENG>                                                   |
//              +---------------------------------------------------------------+
// or
//              31      27      23      19      15      11       7       3     0
//              +-------------------------------+-------------------------------+
//              | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
//              +-------------------------------+-------+-------+-------+-------+
//
//              +-------------------------------+-------+-------+-------+-------+
// u2f-pkt      |         LENG (num of words)   |0 1 0 0|       |TRSNO  |       |
// (come from   +-------------------------------+-------+-------+-------+-------+
//  thread0     | <data 1> (if LENG is 0, there is no data)                     |
//  push        +---------------------------------------------------------------+
//  FIFO_DU2F)  | <data 2>                                                      |
//              +---------------------------------------------------------------+
//              |  .....                                                        |
//              +---------------------------------------------------------------+
//              | <data LENG>                                                   |
//              +---------------------------------------------------------------+
task gpif2_u2f_cmd_core;
     input [ 3:0] cmd   ;
     input [ 3:0] trans ; // TRSNO
     input [15:0] length;
     input        dly; // use random delay for data payload when 1
     integer delay;
     integer idx;
begin
     @ (posedge SL_PCLK);
     u2f_wr_valid = 1'b1;
     u2f_wr_data  = {length,cmd,4'h0,trans,4'h0};
     @ (posedge SL_PCLK);
     while (u2f_wr_ready==1'b0) @ (posedge SL_PCLK);
     for (idx=0; idx<length; idx=idx+1) begin
          if (dly!=1'b0) begin
              u2f_wr_valid = 1'b0;
              delay = ($random(task_seed)%20)&32'h0000_00FF;
              repeat (delay) @ (posedge SL_PCLK);
          end
          u2f_wr_valid = 1'b1;
          u2f_wr_data  = u2f_data[idx];
          @ (posedge SL_PCLK);
          while (u2f_wr_ready==1'b0) @ (posedge SL_PCLK);
     end // for
     u2f_wr_valid = 1'b0;
end
endtask
task gpif2_u2f_dat_core;
     input [ 3:0] cmd   ;
     input [ 3:0] trans ; // TRSNO
     input [15:0] length;
     input        dly; // use random delay for data payload when 1
     integer delay;
     integer idx;
begin
     @ (posedge SL_PCLK);
     u2f_wr_valid = 1'b1;
     u2f_wr_data  = {length,cmd,4'h0,trans,4'h0};
     @ (posedge SL_PCLK);
     while (u2f_wr_ready==1'b0) @ (posedge SL_PCLK);
     u2f_wr_valid = 1'b0;
     for (idx=0; idx<length; idx=idx+1) begin
          if (dly!=1'b0) begin
              u2f_wr_valid = 1'b0;
              delay = ($random(task_seed)%20)&32'h0000_00FF;
              repeat (delay) @ (posedge SL_PCLK);
          end
          u2f_wr_valid = 1'b1;
          u2f_wr_data  = u2f_data[idx];
          @ (posedge SL_PCLK);
          while (u2f_wr_ready==1'b0) @ (posedge SL_PCLK);
     end // for
     u2f_wr_valid = 1'b0;
end
endtask
//------------------------------------------------------------------------------
// Steam USB-to-FPGA without command.
task gpif2_u2f_stream_core;
     input [15:0] length;
     input        dly; // use random delay for data payload when 1
     integer delay;
     integer idx;
begin
     for (idx=0; idx<length; idx=idx+1) begin
          if (dly!=1'b0) begin
              u2f_wr_valid = 1'b0;
              delay = ($random(task_seed)%20)&32'h0000_00FF;
              repeat (delay) @ (posedge SL_PCLK);
          end
          u2f_wr_valid = 1'b1;
          u2f_wr_data  = u2f_data[idx];
          @ (posedge SL_PCLK);
          while (u2f_wr_ready==1'b0) @ (posedge SL_PCLK);
     end // for
     u2f_wr_valid = 1'b0;
end
endtask
//------------------------------------------------------------------------------
//              31      27      23      19      15      11       7       3     0
//              +-------------------------------+-------------------------------+
//              | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
//              +-------------------------------+-------+-------+-------+-------+
//
//              +-------------------------------+-------+-------+-------+-------+
// f2u-pkt      |         LENG (num of words)   |0 1 0 1|       |TRSNO  |       |
// (come from   +-------------------------------+-------+-------+-------+-------+
//  thread2)
// (pop         +-------------------------------+-------+-------+-------+-------+
//  FIFO_DU2F   | <data 1> (if LENG is 0, there is no data)                     |
//  goes to     +---------------------------------------------------------------+
//  thread2)    | <data 2>                                                      |
//              +---------------------------------------------------------------+
//              |  .....                                                        |
//              +---------------------------------------------------------------+
//              | <data LENG>                                                   |
//              +---------------------------------------------------------------+
task gpif2_f2u_dat_core;
     input [ 3:0] trans ;
     input [15:0] length;
     input        dly; // use random delay for data payload when 1
     integer delay;
     integer idx;
begin
     @ (posedge SL_PCLK);
     u2f_wr_valid = 1'b1;
     u2f_wr_data  = {length,CMD_DF2U,4'h0,trans,4'h0};
     @ (posedge SL_PCLK);
     while (u2f_wr_ready==1'b0) @ (posedge SL_PCLK);
     u2f_wr_valid = 1'b0;
     for (idx=0; idx<length; idx=idx+1) begin
          if (dly!=1'b0) begin
              f2u_rd_ready = 1'b0;
              delay = ($random(task_seed)%20)&32'h0000_00FF;
              repeat (delay) @ (posedge SL_PCLK);
          end
          f2u_rd_ready = 1'b1;
          @ (posedge SL_PCLK);
          while (f2u_rd_valid==1'b0) @ (posedge SL_PCLK);
          f2u_data[idx] = f2u_rd_data;
     end // for
     f2u_rd_ready = 1'b0;
end
endtask
//------------------------------------------------------------------------------
// Steam FPGA-to-USB without command.
task gpif2_f2u_stream_core;
     input [15:0] length;
     input        dly; // use random delay for data payload when 1
     integer delay;
     integer idx;
begin
     for (idx=0; idx<length; idx=idx+1) begin
          if (dly!=1'b0) begin
              f2u_rd_ready = 1'b0;
              delay = ($random(task_seed)%20)&32'h0000_00FF;
              repeat (delay) @ (posedge SL_PCLK);
          end
          f2u_rd_ready = 1'b1;
          @ (posedge SL_PCLK);
          while (f2u_rd_valid==1'b0) @ (posedge SL_PCLK);
          f2u_data[idx] = f2u_rd_data;
     end // for
     f2u_rd_ready = 1'b0;
end
endtask
//------------------------------------------------------------------------------
// Revision History
//
// 2019.04.10: '@ (posedge SL_PCLK);' added before 'u2f_wr_valid = 1'b1;'
//              This caused problem with Vivado XSIM.
// 2018.04.13: 'gpif2_f2u_stream_core' and 'gpif2_f2u_stream_core' added.
// 2018.03.07: Started by Ando Ki (adki@future-ds.com)
//------------------------------------------------------------------------------
`endif
