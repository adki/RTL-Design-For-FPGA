`timescale 1ns/1ns

module top;
   reg  in;
   wire out;
   inverter Uinv (out, in);

   initial begin
           in = 0; #10; in = 1; #15;
           in = 0; #20; in = 1; #5
           in = 0; #5
           $finish;
   end
   initial begin
      $dumpfile("wave.vcd");
      $dumpvars(1, out, in);
   end
endmodule

module inverter (out, in);
       output out;
       input  in;
       //-------------------
       supply1 vdd;
       supply0 gnd;
       //-------------------
       pmos #(1) Upmos (out, vdd, in);
       nmos #(3) Unmos (out, gnd, in);
       //-------------------
       pullup   pu (out);
       pulldown pd (out);
endmodule
