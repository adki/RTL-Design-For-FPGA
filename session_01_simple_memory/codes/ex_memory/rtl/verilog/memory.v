//--------------------------------------------------------
// Copyright (c) 2013 by Ando Ki.
// All right reserved.
//
// This program is distributed in the hope that it
// will be useful to understand Ando Ki's work,
// BUT WITHOUT ANY WARRANTY.
//--------------------------------------------------------
`timescale 1ns/1ns
module memory #(parameter ADD_WIDTH=10, DAT_WIDTH=8)
(
     input   wire                 clk
   , input   wire [ADD_WIDTH-1:0] add
   , output  reg  [DAT_WIDTH-1:0] dout
   , input   wire [DAT_WIDTH-1:0] din
   , input   wire                 en
   , input   wire                 we
);
   //-------------------------------------------------
   localparam DELAY = 1;
   localparam DEPTH = 1<<ADD_WIDTH;
   //-------------------------------------------------
   reg [DAT_WIDTH-1:0] mem[0:DEPTH-1];
   //-------------------------------------------------
   always @ (posedge clk) begin
      if (en==1'b1) begin
         if (we==1'b1) begin
            mem[add] <= din;
            dout     <= #(DELAY) din;
         end else begin
            dout     <= #(DELAY) mem[add];
         end
      end
   end
   //-------------------------------------------------
   // synthesis translate_off
   initial dout = 'h0;
   // synthesis translate_on
   //-------------------------------------------------
endmodule
//--------------------------------------------------------
// Revision history:
//
// 2013.07.03.: Started by Ando Ki (adki@future-ds.com)
//--------------------------------------------------------
