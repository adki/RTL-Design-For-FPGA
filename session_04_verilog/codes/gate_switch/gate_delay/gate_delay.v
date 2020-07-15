`timescale 1ns/1ns
module top;
   reg  in1, in2;
   wire out1, out2, out3;
   xor         UxorA (out1, in1, in2);
   xor #(2)    UxorB (out2, in1, in2);
   xor #(3, 4) UxorC (out3, in1, in2);
   initial begin
           in1 = 0; in2 = 0; #5;
           in1 = 1; in2 = 0; #10;
           in1 = 0; in2 = 1; #10;
           in1 = 1; in2 = 1; #10;
           in1 = 0; in2 = 0; #5;
           $finish;
   end
   initial begin
      $dumpfile("wave.vcd");
      $dumpvars(1);
   end
endmodule
