//--------------------------------------------------------
// Copyright (c) 2020 by Ando Ki.
// All right reserved.
//
// This program is distributed in the hope that it
// will be useful to understand Ando Ki's work,
// BUT WITHOUT ANY WARRANTY.
//--------------------------------------------------------
`timescale 1ns/1ns

module top ;
   reg osc_clk = 1'b0;
   always #5 osc_clk <= ~osc_clk; // 100Mhz

   wire    clk_in ;
   wire    clkout0;
   wire    clkout1;
   wire    locked ;
   wire    reset  =1'b0;

   `ifdef differential
   IBUFGDS u_sys_clk_ds(.I  (osc_clk_p)
                       ,.IB (osc_clk_n)
                       ,.O  (clk_in   ));
   `else
   IBUFG u_ibufg(.I(osc_clk), .O(clk_in));
   `endif

   clk_wizard u_clk_wizard (
        .clk_in1  ( clk_in  )
       ,.clk_out1 ( clkout0 )
       ,.clk_out2 ( clkout1 )
       ,.reset    ( reset   )
       ,.locked   ( locked  )
   );

   `define get_frequency(CLK,NAME)\
       repeat (3) @ (posedge (CLK));\
       @ (posedge (CLK)) stamp = $realtime;\
       @ (posedge (CLK)) delta = $realtime - stamp;\
       $display("%s %f-nsec %f-Mhz", (NAME), delta, 1000.0/delta)

   real stamp, delta;
   initial begin
       repeat (5) @ (posedge osc_clk);
       `get_frequency(osc_clk,"osc_clk");
       wait (locked==1'b1);
       `get_frequency(clkout0,"clkout0");
       `get_frequency(clkout1,"clkout1");
       repeat (10) @ (posedge osc_clk);
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
// 2020.07.10.: Started by Ando Ki (adki@future-ds.com)
//--------------------------------------------------------
