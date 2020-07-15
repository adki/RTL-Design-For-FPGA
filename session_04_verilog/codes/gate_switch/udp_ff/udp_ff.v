`timescale 1ns/1ns
module top;
   wire qA, qB;
   reg  clk, data;
   latch X(qA, clk, data);
   ff    Y(qB, clk, data);
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

// level-sensitive sequential UDP 
primitive latch (q, clock, data);
 output q; reg q;
 input clock, data;
 table // clock data qq+
   01 : ? :1 ;
   00 : ? :0 ;
   1? : ? :- ;// - = no change
 endtable
endprimitive

// edge-sensitive sequential UDP
primitive ff (q, clock, data);
 output q; reg q;
 input clock, data;
 table // clock data qq+
 (01)  0 :?:0; // obtain output on rising edge of clock
 (01)  1 :?:1; // obtain output on rising edge of clock
 (0?)  1 :1:1; // obtain output on rising edge of clock
 (0?)  0 :0:0; // obtain output on rising edge of clock
 (?0)  ? :?:-; // ignore negative edge of clock
  ?  (??):?:-; // ignore data changes on steady clock
 endtable
endprimitive
