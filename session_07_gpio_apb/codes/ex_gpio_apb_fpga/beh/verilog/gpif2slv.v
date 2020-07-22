//------------------------------------------------------------------------------
// Copyright (c) 2018 by Future Design Systems.
// All right reserved.
//------------------------------------------------------------------------------
// gpif2slv.v
//------------------------------------------------------------------------------
// VERSION: 2018.02.01.
//------------------------------------------------------------------------------
// Cypress EZ-USB GPIF-II slave interface slave model.
// - EZ-USB model
// - SL_EMPTY_N/SL_PRE_EMPTY_N may not behavior like the actual hardware.
//------------------------------------------------------------------------------
//   +-----------+                        +-----------+
//   | FX3       |                        | gpif2mst  |
//   |           +----> SL_RST_N -------->|-----------+---> SYS_RST_N
//   | gpif2slv  +<---- SL_PCLK ----------+-T-1-+-----|<--- SYS_CLK
//   |           +----- SL_FLAGA -------->|     |     |
//   |           +----- SL_FLAGB -------->|     |     |
//   |           +----- SL_FLAGC -------->|     |     |
//   |           +----- SL_FLAGD -------->|     |     |
//   |           |<---- SL_RD_N ----------|    \_/    |
//   |           |<---- SL_WR_N ----------|           |
//   |           |<---- SL_OE_N ----------|           |
//   |           |<---- SL_PKTEND_N ------|           |
//   |           |<---- SL_AD[1:0] -------|           |
//   |           |<---- SL_DT[31:0] ----->|           |
//   |           +----- SL_MODE[1:0] -----|           |
//   +-----------+                        +-----------+
//------------------------------------------------------------------------------
//   Firmware-controlled           FPGA
//   FIFO in FX3                   gpif2mst
//   <thread0>                     +---------------+
//   --------+     |\              |               +-->transactor_sel[3:0]
//     | | | |====>| \             |    --------+  |
//   --------+     |  \            |      | | | |=====>FIFO_CU2F
//                 |  |<--A[1:0]---|    --------+  |
//                 |  |            |    --------+  |
//                 |  |<==========>|      | | | |=====>FIFO_DU2F
//                 |  |            |    --------+  |
//   <thread2>     |  |  GPIF-II   |      +------- |
//     +-------    |  /            |      | | | |<=====FIFO_DF2U
//     | | | |<====| /             |      +------- |      
//     +-------    |/              +---------------+
//------------------------------------------------------------------------------
// Packet over GPIF-II
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
//
// 'TRSNO' is not used for this implementation.
//
//------------------------------------------------------------------------------
// gpif2slv model
//  +--------------------------------+
//  |                 thread 0       |
//  |                 cmd fifo       |
//  |                 -+-+-+    |\   |
//  |gpif2_u2f_cmd()==>| | |===>| \  |
//  |gpif2_u2f_dat()  -+-+-+    | |  |
//  |                           | |  | SL_AD[1:0]
//  |                           | |<-+---+
//  |                           | |  |   |
//  |                           | |  |   |
//  |                           | |  |   |
//  |                           | |  |   |
//  |                           | |  |   |
//  |                 thread 2  | |<=+=GPIF-II==>
//  |                 f2u fifo  | |  |
//  |                 +-+-+-    | |  |
//  |gpif2_f2u_dat()<=| | |<====| /  |
//  |                 +-+-+-    |/   |
//  |                                |
//  +--------------------------------+
//------------------------------------------------------------------------------
`include "gpif2mst_define.v"
`include "gpif2if_fifo_sync.v"
`ifdef SIM
`include "sim_define.v"
`endif

module gpif2slv
     #(parameter WIDTH_DT=32
               , DEPTH_FIFO_U2F=1024 // command-fifo 4-word unit (USB-to-FPGA)
               , DEPTH_FIFO_F2U=1024 // data stream-out-fifo 4-word unit (FPGA-to-USB)
               , NUM_WATERMARK  =4
               , FPGA_FAMILY    ="ARTIX7") // SPARTAN6, ARTIX7, VIRTEX4
(
     output reg                 SL_RST_N=1'b1
   , input  wire                SL_PCLK
   , input  wire                SL_CS_N
   , input  wire [ 1:0]         SL_AD
   , output wire                SL_FLAGA // thread 0/1, active-low empty (U2F)
   , output wire                SL_FLAGB // thread 0/1, active-low almmost empty
   , output wire                SL_FLAGC // thread 2, active-low full (F2U)
   , output wire                SL_FLAGD // thread 2, active-low almost empty
   , input  wire                SL_RD_N
   , input  wire                SL_WR_N
   , input  wire                SL_OE_N
   , input  wire                SL_PKTEND_N
   , inout  wire [WIDTH_DT-1:0] SL_DT
   , output reg  [ 1:0]         SL_MODE=2'b00
   , input  wire                READY // to keep track of system ready,
                                      // which uses DCM and takes time to be stable.
);
   //---------------------------------------------------------------------------
   localparam WIDTH_FIFO_U2F=clogb2(DEPTH_FIFO_U2F)
            , WIDTH_FIFO_F2U=clogb2(DEPTH_FIFO_F2U);
   //---------------------------------------------------------------------------
   // thread address
   localparam ADD_U2F=`ADD_U2F // USB-to-FPGA for command/data
            , ADD_F2U=`ADD_F2U;// FPGA-to-USB for data
   // command of cmd-pkt
   localparam CMD_CU2F=`CMD_CU2F // COMMAND
            , CMD_DU2F=`CMD_DU2F // DATA (USB-to-FPGA)
            , CMD_DF2U=`CMD_DF2U // DATA (FPGA-to-USB)
            , CMD_REQ =`CMD_REQ ;// Internal request
   // operation mode
   localparam MODE_CMD  =`MODE_CMD  
            , MODE_SU2F =`MODE_SU2F  // stream USB-to-FPGA
            , MODE_SF2U =`MODE_SF2U  // stream FPGA-to-USB
            , MODE_SLOOP=`MODE_SLOOP;
   //---------------------------------------------------------------------------
   reg SL0_EMPTY_N    =1'b0;// thread 0, active-low empty (U2F)
   reg SL0_PRE_EMPTY_N=1'b0;// thread 0, active-low almmost empty
   reg SL2_FULL_N     =1'b0;// thread 2, active-low full (F2U)
   reg SL2_PRE_FULL_N =1'b0;// thread 2, active-low almost empty
   //---------------------------------------------------------------------------
   assign SL_FLAGA = SL0_EMPTY_N    ;// thread 0, active-low empty (U2F)
   assign SL_FLAGB = SL0_PRE_EMPTY_N;// thread 0, active-low almmost empty
   assign SL_FLAGC = SL2_FULL_N     ;// thread 2, active-low full (F2U)
   assign SL_FLAGD = SL2_PRE_FULL_N ;// thread 2, active-low almost empty
   //---------------------------------------------------------------------------
   wire                     u2f_wr_ready;
   reg                      u2f_wr_valid=1'b0;
   reg  [WIDTH_DT-1:0]      u2f_wr_data = 'h0;
   reg                      u2f_rd_ready=1'b0;
   wire                     u2f_rd_valid;
   wire [WIDTH_DT-1:0]      u2f_rd_data ;
   wire                     u2f_full    ;
   wire                     u2f_empty   ;
   wire                     u2f_fullN   ;
   wire                     u2f_emptyN  ;
   wire [WIDTH_FIFO_U2F:0]  u2f_items   ;
   wire [WIDTH_FIFO_U2F:0]  u2f_rooms   ;
   //---------------------------------------------------------------------------
   wire                     f2u_wr_ready;
   reg                      f2u_wr_valid=1'b0;
   reg  [WIDTH_DT-1:0]      f2u_wr_data ;
   reg                      f2u_rd_ready=1'b0;
   wire                     f2u_rd_valid;
   wire [WIDTH_DT-1:0]      f2u_rd_data ;
   wire                     f2u_full    ;
   wire                     f2u_empty   ;
   wire                     f2u_fullN   ;
   wire                     f2u_emptyN  ;
   wire [WIDTH_FIFO_F2U:0]  f2u_items   ;
   wire [WIDTH_FIFO_F2U:0]  f2u_rooms   ;
   //---------------------------------------------------------------------------
   `include "gpif2slv_tasks.v"
   `include "gpif2slv_trx_axi_tasks.v"
   //---------------------------------------------------------------------------
   reg done=1'b0;
   integer error;
   integer idx, idy, idz;
   reg [31:0] dataR, dataW;
   reg fiq, irq; // active-high
   reg [4:0] gpin, gpout;
   reg [31:0] value;
   integer random_seed;
   reg [31:0] store[0:4095];
   //---------------------------------------------------------------------------
localparam TEST_INFO       =`TEST_INFO
         , TEST_GPIO_CSR   =`TEST_GPIO_CSR
         ;
   //---------------------------------------------------------------------------
   localparam CSRA_GPIO_ADD=32'h0000_0000;
   localparam CSRA_CONTROL =CSRA_GPIO_ADD+8'h00,
              CSRA_LINE    =CSRA_GPIO_ADD+8'h04,
              CSRA_MASK    =CSRA_GPIO_ADD+8'h08,
              CSRA_IRQ     =CSRA_GPIO_ADD+8'h0C,
              CSRA_EDGE    =CSRA_GPIO_ADD+8'h10,
              CSRA_POL     =CSRA_GPIO_ADD+8'h14;
   //---------------------------------------------------------------------------
   initial begin
       done      = 1'b0;
       SL_RST_N  = 1'b1;
       SL_MODE   = 2'b0;
       #7;
       SL_RST_N  = 1'b0;
       #55;
       SL_RST_N  = 1'b1;
       wait (READY==1'b1);
       gpif2_mode(MODE_CMD);
       wait (READY==1'b1);
       //-----------------------------------------------------------------------
if (TEST_INFO) begin
       gpif2_get_info();
       $display("%m GPIF2MST VERSION 0x%08X", f2u_data[2]);
       $display("%m CU2F-FIFO=%d DU2F-FIFO=%d, DF2U-FIFO=%d",
                 f2u_data[1]&32'hFFFF, f2u_data[0]&32'hFFFF, (f2u_data[0]>>16)&32'hFFFF);
       $display("%m GPIF2MST CLK FREQ %d-Mhz %s", (f2u_data[1]>>16)&16'hFF
                                                , (f2u_data[1]&32'h0100_0000)
                                                  ? "INVERTED" : "NOT-INVERTED");
end
       //-----------------------------------------------------------------------
if (TEST_GPIO_CSR) begin
       axi_read(CSRA_CONTROL, 4, dataR); $display("%m %t %s A:0x%08X D:0x%08X OK", $time, "CONTROL", CSRA_CONTROL, dataR);
       axi_read(CSRA_LINE   , 4, dataR); $display("%m %t %s A:0x%08X D:0x%08X OK", $time, "LINE   ", CSRA_LINE   , dataR);
       axi_read(CSRA_MASK   , 4, dataR); $display("%m %t %s A:0x%08X D:0x%08X OK", $time, "MASK   ", CSRA_MASK   , dataR);
       axi_read(CSRA_IRQ    , 4, dataR); $display("%m %t %s A:0x%08X D:0x%08X OK", $time, "IRQ    ", CSRA_IRQ    , dataR);
       axi_read(CSRA_EDGE   , 4, dataR); $display("%m %t %s A:0x%08X D:0x%08X OK", $time, "EDGE   ", CSRA_EDGE   , dataR);
       axi_read(CSRA_POL    , 4, dataR); $display("%m %t %s A:0x%08X D:0x%08X OK", $time, "POL    ", CSRA_POL    , dataR);
end
       //-----------------------------------------------------------------------
       repeat (10) @ (posedge SL_PCLK);
       done = 1'b1;
       //-----------------------------------------------------------------------
   end // initial
   //---------------------------------------------------------------------------
   reg SL_RD_N0=1'b1;
   always @ (posedge SL_PCLK or negedge SL_RST_N) begin
   if (SL_RST_N==1'b0) begin
       SL_RD_N0       <= 1'b1;
   end else begin
       SL_RD_N0       <= SL_RD_N;
   end
   end // always
   //---------------------------------------------------------------------------
   reg [WIDTH_DT-1:0] SL_DT_O;
   reg [WIDTH_DT-1:0] SL_DT_O_reg={WIDTH_DT{1'b0}};
   assign SL_DT = (SL_OE_N==1'b0) ? SL_DT_O : {WIDTH_DT{1'bZ}};
   //---------------------------------------------------------------------------
   always @ ( * ) begin
       SL0_EMPTY_N     = 1'b0;
       SL0_PRE_EMPTY_N = 1'b0;
       SL2_FULL_N      = 1'b1;
       SL2_PRE_FULL_N  = 1'b1;
       f2u_wr_valid    = 1'b0;
       u2f_rd_ready    = 1'b0;
       u2f_rd_ready    = 1'b0;
   if (SL_RST_N==1'b1) begin
       SL0_EMPTY_N     = ~u2f_empty ;
       SL0_PRE_EMPTY_N = ~u2f_emptyN;
       SL2_FULL_N      = ~f2u_full  ;
       SL2_PRE_FULL_N  = ~f2u_fullN ;
       f2u_wr_valid    = 1'b0;
       u2f_rd_ready    = 1'b0;
       u2f_rd_ready    = 1'b0;
       if (SL_AD==ADD_U2F) begin
           u2f_rd_ready  =~SL_RD_N0;
           SL_DT_O       = (SL_OE_N==1'b0) ? SL_DT_O_reg : 32'hZ;
           if ((SL_RD_N==1'b0)&&(SL_OE_N==1'b1)) $display("%m %t ERROR SL_OE_N should be 0 for F2U", $time);
           if ((SL_RD_N==1'b0)&&(SL_WR_N==1'b0)) $display("%m %t ERROR SL_RD_N & SL_WR_N both low", $time);
       end else if (SL_AD==ADD_F2U) begin
           f2u_wr_valid  =~SL_WR_N;
           f2u_wr_data   = SL_DT;
           if ((SL_WR_N==1'b0)&&(SL_OE_N==1'b0)) $display("%m %t ERROR SL_OE_N should be 1 for F2U", $time);
           if ((SL_RD_N==1'b0)&&(SL_WR_N==1'b0)) $display("%m %t ERROR SL_RD_N & SL_WR_N both low", $time);
       end else begin
           if ($time>10) $display("%m %t un-supprted SL_AD: %2b", SL_AD, $time, SL_AD);
       end
   end else begin
       SL0_EMPTY_N     = 1'b0;
       SL0_PRE_EMPTY_N = 1'b0;
       SL2_FULL_N      = 1'b1;
       SL2_PRE_FULL_N  = 1'b1;
       u2f_rd_ready    = 1'b0;
       u2f_rd_ready    = 1'b0;
       f2u_wr_valid    = 1'b0;
       f2u_wr_data     = 32'hZ;
   end
   end // always
   //---------------------------------------------------------------------------
   // It holds SL_DT data.
   always @ (posedge SL_PCLK or negedge SL_RST_N) begin
   if (SL_RST_N==1'b0) begin
       SL_DT_O_reg={WIDTH_DT{1'b0}};
   end else begin
       if (SL_AD==ADD_U2F) begin
           if ((u2f_rd_ready==1'b1)&&(u2f_rd_valid==1'b1)) SL_DT_O_reg <= u2f_rd_data;
       end else begin
           if ((u2f_rd_ready==1'b1)&&(u2f_rd_valid==1'b1)) SL_DT_O_reg <= u2f_rd_data;
       end
   end // if
   end // always
   //---------------------------------------------------------------------------
   gpif2if_fifo_sync #(.FDW (WIDTH_DT) // fifof data width
                      ,.FAW (WIDTH_FIFO_U2F) // num of entries in 2 to the power FAW
                      ,.FULN(NUM_WATERMARK*32/WIDTH_DT-4)// lookahead-full
                      ,.EMPTN(NUM_WATERMARK*32/WIDTH_DT-1))// lookahead-empty
   u_u2f (
          .rst     (~SL_RST_N     )
        , .clr     ( 1'b0         )
        , .clk     ( SL_PCLK      )
        , .wr_rdy  ( u2f_wr_ready )
        , .wr_vld  ( u2f_wr_valid )
        , .wr_din  ( u2f_wr_data  )
        , .rd_rdy  ( u2f_rd_ready )
        , .rd_vld  ( u2f_rd_valid )
        , .rd_dout ( u2f_rd_data  )
        , .full    ( u2f_full     )
        , .empty   ( u2f_empty    )
        , .fullN   ( u2f_fullN    )
        , .emptyN  ( u2f_emptyN   )
        , .rd_cnt  ( u2f_items    )
        , .wr_cnt  ( u2f_rooms    )
   );
   //---------------------------------------------------------------------------
   gpif2if_fifo_sync #(.FDW (WIDTH_DT) // fifof data width
                      ,.FAW (WIDTH_FIFO_F2U) // num of entries in 2 to the power FAW
                      ,.FULN(NUM_WATERMARK*32/WIDTH_DT-4)// lookahead-full
                      ,.EMPTN(NUM_WATERMARK*32/WIDTH_DT-1))// lookahead-empty
   u_f2u (
          .rst     (~SL_RST_N     )
        , .clr     ( 1'b0         )
        , .clk     ( SL_PCLK      )
        , .wr_rdy  ( f2u_wr_ready )
        , .wr_vld  ( f2u_wr_valid )
        , .wr_din  ( f2u_wr_data  )
        , .rd_rdy  ( f2u_rd_ready )
        , .rd_vld  ( f2u_rd_valid )
        , .rd_dout ( f2u_rd_data  )
        , .full    ( f2u_full     )
        , .empty   ( f2u_empty    )
        , .fullN   ( f2u_fullN    )
        , .emptyN  ( f2u_emptyN   )
        , .rd_cnt  ( f2u_items    )
        , .wr_cnt  ( f2u_rooms    )
   );
   //---------------------------------------------------------------------------
   function integer clogb2;
   input [31:0] value;
   reg   [31:0] tmp;
   begin
      tmp = value - 1;
      for (clogb2 = 0; tmp > 0; clogb2 = clogb2 + 1) tmp = tmp >> 1;
   end
   endfunction
   //---------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
// Revision History
//
// 2018.03.07: Started by Ando Ki (adki@future-ds.com)
//------------------------------------------------------------------------------
