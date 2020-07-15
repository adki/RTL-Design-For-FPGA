//--------------------------------------------------------
// Copyright (c) 2013 by Ando Ki.
// All right reserved.
//
// This program is distributed in the hope that it
// will be useful to understand Ando Ki's work,
// BUT WITHOUT ANY WARRANTY.
//--------------------------------------------------------
`timescale 1ns/1ns
module tester #(parameter ADD_WIDTH=10, DAT_WIDTH=8)
(
     input   wire                 clk
   , output  reg  [ADD_WIDTH-1:0] add
   , output  reg  [DAT_WIDTH-1:0] dataW
   , input   wire [DAT_WIDTH-1:0] dataR
   , output  reg                  en
   , output  reg                  we
);
   //-------------------------------------------------
   reg done = 1'b0;
   //-------------------------------------------------
   localparam DEPTH = 1<<ADD_WIDTH;
   localparam DELAY = 1;
   //-------------------------------------------------
   initial begin
      add   =  'h0;
      dataW =  'h0;
      en    = 1'b0;
      we    = 1'b0;
      repeat (5) @ (posedge clk);
      read_after_write(0, 'h100);
      repeat (5) @ (posedge clk);
      read_all_after_write_all(0, 'h100);
      repeat (5) @ (posedge clk);
      done = 1'b1;
   end
   //-------------------------------------------------
   task read_after_write;
   input  [ADD_WIDTH-1:0] AS; // starting (inclusive)
   input  [ADD_WIDTH-1:0] AE; // ending (exclusive)
   reg    [ADD_WIDTH-1:0] idx; // starting (inclusive)
   reg    [DAT_WIDTH-1:0] valW, valR;
   integer error;
   begin
       error = 0;
       for (idx=AS; idx<AE; idx=idx+1) begin
            valW = idx+1;
            write(idx, valW);
            read (idx, valR);
            if (valR!=valW) begin
                error = error + 1;
                $display($time,,"%m ERROR at A:0x%08x D:0x%02x, but D:0x%02x expected",
                                 idx, valR, valW);
            end
       end
       if (error==0) $display($time,,"%m test RAW pass");
   end
   endtask
   //-------------------------------------------------
   task read_all_after_write_all;
   input  [ADD_WIDTH-1:0] AS; // starting (inclusive)
   input  [ADD_WIDTH-1:0] AE; // ending (exclusive)
   begin
   // fill
   end
   endtask
   //-------------------------------------------------
   task write;
   input  [ADD_WIDTH-1:0] A;
   input  [DAT_WIDTH-1:0] D;
   begin
       @ (posedge clk);
       add   <= #(DELAY) A;
       dataW <= #(DELAY) D;
       en    <= #(DELAY) 1'b1;
       we    <= #(DELAY) 1'b1;
       @ (posedge clk);
       en  <= #(DELAY) 1'b0;
       we  <= #(DELAY) 1'b0;
       @ (posedge clk);
   end
   endtask
   //-------------------------------------------------
   task read;
   input  [ADD_WIDTH-1:0] A;
   output [DAT_WIDTH-1:0] D;
   begin
       we  = 1'b0;
       @ (posedge clk);
       add <= A;
       en  <= #(DELAY) 1'b1;
       @ (posedge clk);
       en  <= #(DELAY) 1'b0;
       @ (posedge clk);
       D = dataR;
   end
   endtask
   //-------------------------------------------------
endmodule
//--------------------------------------------------------
// Revision history:
//
// 2013.07.03.: Started by Ando Ki (adki@future-ds.com)
//--------------------------------------------------------
