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
`define CLK_FREQ     100000000 // 100Mhz
`endif

module top ;
   localparam CLK_FREQ=`CLK_FREQ;
   localparam CLK_PERIOD_HALF=1000000000/(CLK_FREQ*2);

   reg clkA = 1'b0;

   always #(CLK_PERIOD_HALF) clkA = ~clkA; //always clkA = #(CLK_PERIOD_HALF) ~clkA;

   reg clkB = 1'b1;
   initial forever #(CLK_PERIOD_HALF) clkB = ~clkB;

   real stamp, delta;
   initial begin
       repeat (10) @ (posedge clkA);
       @ (posedge clkA) stamp = $time;
       @ (posedge clkA) delta = $time - stamp;
       $display("%m clkA %f nsec %f Mhz", delta, 1000.0/delta);
       repeat (10) @ (posedge clkB);
       @ (posedge clkB) stamp = $time;
       @ (posedge clkB) delta = $time - stamp;
       $display("%m clkB %f nsec %f Mhz", delta, 1000.0/delta);
       repeat (10) @ (posedge clkB);
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
