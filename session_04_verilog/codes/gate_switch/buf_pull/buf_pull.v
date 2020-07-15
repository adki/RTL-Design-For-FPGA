`timescale 1ns/1ns
module top;
   reg  data, cont;
   tri  resultA, resultB;
   tri  resultPA, resultPB;
   // without pull-up/down
   bufif1 Ua  (resultA, data, cont);
   notif0 Ub  (resultB, data, cont);
   // with pull-up/down
   bufif1 Upa (resultPA, data, cont);
   notif0 Upb (resultPB, data, cont);
   pulldown   (resultPA);
   pullup     (resultPB);
   initial begin
           data = 0;
           cont = 0;
       #5  cont = 1;
       #5  cont = 0;
       #5  data = 1;
       #5  cont = 1;
       #5  cont = 0;
       #5  $finish;
   end
   initial begin
      $dumpfile("wave.vcd");
      $dumpvars(1, data, cont, resultA, resultB);
      $dumpvars(1, resultPA, resultPB);
   end
endmodule
