`timescale 1ns/1ns
module top;
   wire q, qb;
   reg  clk, data;
   dff dff (.q(q), .qb(qb), .clk(clk), .d(data));
   initial begin
       #10;
       clk = 1'b0; data = 1'b0; #10;
       clk = 1'b0; data = 1'b1; #10;
       clk = 1'b0; data = 1'b0; #10;
       clk = 1'b0; data = 1'b1; #10;
       #10;
       clk = 1'b1; data = 1'b0; #10;
       clk = 1'b1; data = 1'b1; #10;
       clk = 1'b1; data = 1'b0; #10;
       clk = 1'b1; data = 1'b1; #10;
       #10;
                   data = 1'b0; #10;
       clk = 1'b0;              #10;
       clk = 1'b1;              #10;
       #10;
                   data = 1'b1; #10;
       clk = 1'b0;              #10;
       clk = 1'b1;              #10;
       #10;
                   data = 1'b1; #10;
       clk = 1'b0;              #10;
       clk = 1'b1;              #10;
       #10;
                   data = 1'b0; #10;
       clk = 1'b0;              #10;
       clk = 1'b1;              #10;
       #10;
       clk = 1'b0; data = 1'b0; #10;
       $finish;
   end
   initial begin
      $dumpfile("wave.vcd");
      $dumpvars(1);
   end
endmodule

primitive dff1 (q, clk, d);
 input clk, d;
 output q;  reg q;
 initial q = 1'b1;
 table // clkdqq+
   r0:?:0; // r: rising (01)
   r1:?:1;
   f?:?:-; // f: falling (10)
   ?*:?:-; // *: any value change (??)
 endtable
endprimitive

module dff (q, qb, clk, d);
 input clk, d;
 output q, qb;
 wire qi;
 dff1   g1 (qi, clk, d);
 buf #3 g2 (q, qi);
 not #5 g3 (qb, qi);
endmodule
