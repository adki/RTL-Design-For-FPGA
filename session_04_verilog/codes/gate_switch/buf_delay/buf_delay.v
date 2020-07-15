`timescale 1ns/1ns
module top;
   reg  in, con;
   wire out;
   bufif1 #(1, 3, 2) Ub (out, in, con);
   initial begin
           con = 0; #2;
           in  = 0; #5;  con = 1; #5; con = 0; #5; con = 1; #5;
           in  = 1; #5;  con = 0; #5; con = 1; #5;
           in  = 0; #5;  con = 0; #5; con = 1; #5;
           $finish;
   end
   initial begin
      $dumpfile("wave.vcd");
      $dumpvars(1);
   end
endmodule
