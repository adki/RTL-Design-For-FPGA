`timescale 1ns/1ns
module top;
   wire outX, outY;
   reg  control, dataA, dataB;
   muxX X(outX, control, dataA, dataB);
   muxY Y(outY, control, dataA, dataB);
   initial begin
       #10;
       control = 1'b0; dataA = 1'b0; dataB = 1'b0; #10;
       control = 1'b0; dataA = 1'b0; dataB = 1'b1; #10;
       control = 1'b0; dataA = 1'b0; dataB = 1'bX; #10;
       control = 1'b0; dataA = 1'b1; dataB = 1'b0; #10;
       control = 1'b0; dataA = 1'b1; dataB = 1'b1; #10;
       control = 1'b0; dataA = 1'b1; dataB = 1'bX; #10;
       control = 1'b0; dataA = 1'bX; dataB = 1'b0; #10;
       control = 1'b0; dataA = 1'bX; dataB = 1'b1; #10;
       control = 1'b0; dataA = 1'bX; dataB = 1'bX; #10;
       #10;
       control = 1'b1; dataA = 1'b0; dataB = 1'b0; #10;
       control = 1'b1; dataA = 1'b1; dataB = 1'b0; #10;
       control = 1'b1; dataA = 1'bX; dataB = 1'b0; #10;
       control = 1'b1; dataA = 1'b0; dataB = 1'b1; #10;
       control = 1'b1; dataA = 1'b1; dataB = 1'b1; #10;
       control = 1'b1; dataA = 1'bX; dataB = 1'b1; #10;
       control = 1'b1; dataA = 1'b0; dataB = 1'bX; #10;
       control = 1'b1; dataA = 1'b1; dataB = 1'bX; #10;
       control = 1'b1; dataA = 1'bX; dataB = 1'bX; #10;
       #10;
       control = 0; dataA = 0; dataB = 0; #10;
       $finish;
   end
   initial begin
      $dumpfile("wave.vcd");
      $dumpvars(1);
   end
endmodule

primitive muxX (mux, control, dataA, dataB);
 output mux;
 input control, dataA, dataB;
 table // control dataA dataB mux
   01 0 : 1 ;
   01 1 : 1 ;
   01 x : 1 ;
   00 0 : 0 ;
   00 1 : 0 ;
   00 x : 0 ;
   10 1 : 1 ;
   11 1 : 1 ;
   1x 1 : 1 ;
   10 0 : 0 ;
   11 0 : 0 ;
   1x 0 : 0 ;
   x0 0 : 0 ;
   x1 1 : 1 ;
 endtable
endprimitive

primitive muxY (mux, control, dataA, dataB);
 output mux;
 input control, dataA, dataB;
 table // control dataA dataB mux
    01?:1 ; // ? = 0 1 x
    00?:0 ;
    1?1:1 ;
    1?0:0 ;
    x00:0 ;
    x11:1 ;
 endtable
endprimitive
