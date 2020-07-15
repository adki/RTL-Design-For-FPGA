`timescale 1ns/1ns
module top;
   reg a;
   reg [3:0] b;
   reg [3:0] i, j;
   initial begin
           for (i=0; i<=5; i=i+1)          a <= # (i*10) i[0];
           for (j=0; j<=5; j=j+1) # (j*10) b <= j;
   end
   initial begin
            $dumpfile("wave.vcd");
            $dumpvars(1);
            #1000 $finish;
   end
endmodule
