//--------------------------------------------------------
// Copyright (c) 2013 by Ando Ki.
// All right reserved.
//
// This program is distributed in the hope that it
// will be useful to understand Ando Ki's work,
// BUT WITHOUT ANY WARRANTY.
//--------------------------------------------------------
`timescale 1ns/1ns

`ifndef CLK_FREQ
`define CLK_FREQ     50000000 // 50Mhz
`endif

module top ;
   localparam CLK_FREQ=`CLK_FREQ;
   localparam CLK_PERIOD_HALF=1000000000/(CLK_FREQ*2);
   reg clk = 1'b0;
   always #CLK_PERIOD_HALF clk <= ~clk;

   localparam ADD_WIDTH=10
            , DAT_WIDTH=8;

   wire [ADD_WIDTH-1:0] add ;
   wire [DAT_WIDTH-1:0] dataW;
   wire [DAT_WIDTH-1:0] dataR;
   wire                 en ;
   wire                 we ;

   memory
          `ifndef GATESIM
          #(.ADD_WIDTH(ADD_WIDTH),.DAT_WIDTH(DAT_WIDTH))
          `endif
   u_memory (
       .clk  (clk  )
     , .add  (add  )
     , .dout (dataR)
     , .din  (dataW)
     , .en   (en   )
     , .we   (we   )
   );

   tester #(.ADD_WIDTH(ADD_WIDTH),.DAT_WIDTH(DAT_WIDTH))
   u_tester (
       .clk  (clk  )
     , .add  (add  )
     , .dataR(dataR)
     , .dataW(dataW)
     , .en   (en   )
     , .we   (we   )
   );

   initial begin
       wait (u_tester.done==1'b1);
       $finish(2);
   end

   initial begin
       $dumpfile("wave.vcd");
       $dumpvars(0);
   end

endmodule
//--------------------------------------------------------
// Revision history:
//
// 2013.07.03.: Started by Ando Ki (adki@future-ds.com)
//--------------------------------------------------------
