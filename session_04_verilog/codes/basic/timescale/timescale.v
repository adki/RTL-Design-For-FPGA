`timescale 10 ns / 1 ns 
module top;
  integer set;
  parameter d = 1.55;
  initial begin
        set = 0;
     #d set = 1; // 1.55*10   --> 15.5 --> 16
     #d set = 2; // 16+1.55*10 --> 31.5 --> 32
     #d set = 3; // 32+1.55*10 --> 47.5 --> 48
     #d set = 4; // 48+1.55*10 --> 63.5 --> 64
  end
  initial begin
     $dumpfile("wave.vcd");
     $dumpvars(1);
  end
endmodule
