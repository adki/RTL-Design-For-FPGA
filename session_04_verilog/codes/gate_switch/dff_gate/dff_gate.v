`timescale 1ns/1ns
module top;
   reg d, clk;
   wire q, qb;
   initial begin
       clk = 0;
       forever #5 clk = ~clk;
   end
   initial begin
       d = 0; #7;
       d = 1; #10;
       d = 0; #10;
       d = 1; #10;
       d = 0; #10;
       $finish;
   end
   dff Udff (q, qb, d, clk);
endmodule

module dff (q, qb, d, clk);
   output q, qb;
   input  d, clk;
   wire   x, y;
   nand #1 U1 (q, x, qb);
   nand #1 U2 (qb, q, y);
   nand #1 U3 (x, d, clk);
   nand #1 U4 (y, x, clk);
   initial begin
      $dumpfile("wave.vcd");
      $dumpvars(1, clk, d, q, qb);
      $dumpvars(1, x, y);
   end
endmodule
