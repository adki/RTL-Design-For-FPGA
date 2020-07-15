`timescale 1ns/1ns

module top;
   reg data, cont;
   trireg           capA;
   trireg #(1,2,10) capB;
   nmos UA(capA, data, cont);
   nmos UB(capB, data, cont);
   initial begin
     //$monitor("%0d data=%v cont=%v cap=%v", $time, data, cont, cap);
     data = 1; cont = 0; #5;
               cont = 1; #10;
     data = 0; cont = 0; #30;
               cont = 1; #10;
               cont = 0; #30;
               cont = 1; #5;
     #30 $finish;
   end
   initial begin
      $dumpfile("wave.vcd");
      $dumpvars(1, data, cont, capA, capB);
   end
endmodule
