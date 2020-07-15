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
   always #10 osc_clk <= ~osc_clk; // 50Mhz

   wire    clk_in ;
   wire    clkout0;
   wire    clkout1;
   wire    clkout2;
   wire    clkout3;
   wire    clkout4;
   wire    locked ;
   wire    reset  =1'b0;

   `ifdef differential
   IBUFGDS u_sys_clk_ds(.I  (osc_clk_p)
                       ,.IB (osc_clk_n)
                       ,.O  (clk_in   ));
   `else
   IBUFG u_ibufg(.I(osc_clk), .O(clk_in));
   `endif

   clkmgra #(.INPUT_CLOCK_FREQ( 50_000_000)
            ,.CLKOUT0_FREQ    ( 80_000_000)
            ,.CLKOUT1_FREQ    (100_000_000)
            ,.CLKOUT2_FREQ    (150_000_000)
            ,.CLKOUT3_FREQ    (200_000_000)
            ,.CLKOUT4_FREQ    (500_000_000)
            ,.FPGA_FAMILY     ("z7"))
   u_clkmgra (
          .CLK_IN  ( clk_in  )
        , .CLKOUT0 ( clkout0 )
        , .CLKOUT1 ( clkout1 )
        , .CLKOUT2 ( clkout2 )
        , .CLKOUT3 ( clkout3 )
        , .CLKOUT4 ( clkout4 )
        , .LOCKED  ( locked  )
        , .RESET   ( reset   )
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
       `get_frequency(clkout2,"clkout2");
       `get_frequency(clkout3,"clkout3");
       `get_frequency(clkout4,"clkout4");
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
