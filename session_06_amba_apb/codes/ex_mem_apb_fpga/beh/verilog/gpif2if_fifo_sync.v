`ifndef GPIF2IF_FIFO_SYNC_V
`define GPIF2IF_FIFO_SYNC_V
//----------------------------------------------------------------
//  Copyright (c) 2019 by Future Design Systems Co., Ltd.
//  All right reserved.
//  http://www.future-ds.com
//----------------------------------------------------------------
// gpif2if_fifo_sync.v
//----------------------------------------------------------------
// Synchronous FIFO
//----------------------------------------------------------------
// VERSION: 2019.04.10.
//----------------------------------------------------------------
// MACROS and PARAMETERS
//     XILINX_DPRAM: define this for Xilinx BRAM
//     DONGBU_018_DPRAM: define this for Dongbu 0.18n
//----------------------------------------------------------------
// Features
//    * ready-valid handshake protocol
//    * lookahead full and empty -- see fullN and emptyN
//    * First-Word Fall-Through, but rd_vld indicates its validity
//----------------------------------------------------------------
//    * data moves when both ready(rdy) and valid(vld) is high.
//    * ready(rdy) means the receiver is ready to accept data.
//    * valid(vld) means the data is valid on 'data'.
//----------------------------------------------------------------
//
//               ___   _____   _____   _____   ____
//   clk           |___|   |___|   |___|   |___|
//               _______________________________
//   wr_rdy     
//                     _________________
//   wr_vld      ______|       ||      |___________  
//                      _______  ______
//   wr_din      XXXXXXX__D0___XX__D1__XXXX
//               ______________                        ____
//   empty                     |_______________________|
//                                     _________________
//   rd_rdy      ______________________|               |___
//                                     ________________
//   rd_vld      ______________________|       ||      |___
//                                      ________ _______
//   rd_dout     XXXXXXXXXXXXXXXXXXXXXXX__D0____X__D1___XXXX
//
//   full        __________________________________________
//
//----------------------------------------------------------------

module gpif2if_fifo_sync
       #(parameter FDW =32,  // fifof data width
                   FAW =5,  // num of entries in 2 to the power FAW
                   FULN=4,  // lookahead-full
                   EMPTN=4)  // lookahead-full
(
       input   wire           rst // asynchronous reset (active high)
     , input   wire           clr // synchronous reset (active high)
     , input   wire           clk
     , output  wire           wr_rdy
     , input   wire           wr_vld
     , input   wire [FDW-1:0] wr_din
     , input   wire           rd_rdy
     , output  wire           rd_vld
     , output  wire [FDW-1:0] rd_dout
     , output  wire           full
     , output  wire           empty
     , output  wire           fullN  // lookahead full
     , output  wire           emptyN // lookahead empty
     , output  reg  [FAW:0]   rd_cnt // num of elements in the FIFO to be read
     , output  wire [FAW:0]   wr_cnt // num of rooms in the FIFO to be written
);
   //---------------------------------------------------
   localparam FDT = 1<<FAW;
   //---------------------------------------------------
   reg  [FAW:0]   fifo_head = 'h0; // where data to be read
   reg  [FAW:0]   fifo_tail = 'h0; // where data to be written
   reg  [FAW:0]   next_tail = 'h1;
   reg  [FAW:0]   next_head = 'h1;
   wire [FAW-1:0] write_addr = fifo_tail[FAW-1:0];
   `ifdef SIM
   wire [FAW-1:0] read_addr  = (rst==1'b1) ? {FAW{1'b0}} : fifo_head[FAW-1:0];
   `else
   wire [FAW-1:0] read_addr  = fifo_head[FAW-1:0];
   `endif
   //---------------------------------------------------
   // accept input
   // push data item into the entry pointed by fifo_tail
   //
   always @(posedge clk or posedge rst) begin
      if (rst==1'b1) begin
          fifo_tail <= 0;
          next_tail <= 1;
      end else if (clr==1'b1) begin
          fifo_tail <= 0;
          next_tail <= 1;
      end else begin
          if ((full==1'b0) && (wr_vld==1'b1)) begin
              fifo_tail <= next_tail;
              next_tail <= next_tail + 1;
          end 
      end
   end
   //---------------------------------------------------
   // provide output
   // pop data item from the entry pointed by fifo_head
   //
   always @(posedge clk or posedge rst) begin
      if (rst==1'b1) begin
          fifo_head <= 0;
          next_head <= 1;
      end else if (clr==1'b1) begin
          fifo_head <= 0;
          next_head <= 1;
      end else begin
          if ((empty==1'b0) && (rd_rdy==1'b1)) begin
              fifo_head <= next_head;
              next_head <= next_head + 1;
          end
      end
   end
   //---------------------------------------------------
   // how many items in the FIFO
   //
   assign  wr_cnt = FDT-rd_cnt;
   always @(posedge clk or posedge rst) begin
      if (rst==1'b1) begin
         rd_cnt <= 0;
      end else if (clr==1'b1) begin
         rd_cnt <= 0;
      end else begin
       //if (wr_vld&&!full&&(!rd_rdy||(rd_rdy&&empty))) begin
         if ((wr_vld==1'b1)&&(full==1'b0)&&((rd_rdy==1'b0)||((rd_rdy==1'b1)&&(empty==1'b1)))) begin
             rd_cnt <= rd_cnt + 1;
         end else
       //if (rd_rdy&&!empty&&(!wr_vld||(wr_vld&&full))) begin
         if ((rd_rdy==1'b1)&&(empty==1'b0)&&((wr_vld==1'b0)||((wr_vld==1'b1)&&(full==1'b1)))) begin
             rd_cnt <= rd_cnt - 1;
         end
      end
   end
   
   //---------------------------------------------------
   assign rd_vld = ~empty;
   assign wr_rdy = ~full;
   assign empty  = (fifo_head == fifo_tail);
   assign full   = (rd_cnt>=FDT);
   //---------------------------------------------------
   assign fullN  = (rd_cnt>=(FDT-FULN));
   assign emptyN = (rd_cnt<=EMPTN);
   //---------------------------------------------------
   reg [FDW-1:0] Mem [0:FDT-1];
   assign rd_dout  = (empty==1'b1) ? {FDW{1'bX}} : Mem[read_addr];
   always @(posedge clk) begin
       if ((full==1'b0) && (wr_vld==1'b1)) begin
           Mem[write_addr] <= wr_din;
       end
   end
   //---------------------------------------------------
   // synopsys translate_off
   `ifdef RIGOR
   integer idx;
   initial begin
           for (idx=0; idx<FDT; idx=idx+1) begin
                Mem[idx] = 'hX;
           end
   end
   `endif
   // synopsys translate_on
   //---------------------------------------------------
   // synopsys translate_off
   `ifdef RIGOR
   always @(negedge clk or posedge rst) begin
      if ((rst==1'b0) && (clr==1'b0)) begin
          if ((rd_cnt==0)&&(empty==1'b0))
             $display($time,, "%m: empty flag mis-match: %d", rd_cnt);
          if ((rd_cnt==FDT)&&(full==1'b0))
             $display($time,, "%m: full flag mis-match: %d", rd_cnt);
          if (rd_cnt>FDT)
             $display($time,, "%m: fifo handling error: rd_cnt>FDT %d:%d", rd_cnt, FDT);
          if ((rd_cnt+wr_cnt)!=FDT)
             $display($time,, "%m: count mis-match: rd_cnt:wr_cnt %d:%d", rd_cnt, wr_cnt);
      end
   end
   `endif
   // synopsys translate_on
   //---------------------------------------------------
   // synopsys translate_off
  //`ifdef RIGOR
  //initial begin
  //    if (FAW!=5) $display("%m FAW should be 5, but %d", FAW);
  //    if (FDW!=32) $display("%m FDW should be 32, but %d", FDW);
  //end
  //`endif
   // synopsys translate_on
endmodule
//----------------------------------------------------------------
// Revision History
//
// 2019.04.10: conditions in the 'if ()' have been clarified.
//             timescale has been removed.
// 2018.03.07: Starting [adki]
//----------------------------------------------------------------
`endif
