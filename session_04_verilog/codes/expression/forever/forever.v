module top;
  reg clkA, clkB;
  initial begin
     clkA = 0;
     forever #5 clkA = ~clkA;
  end
  initial begin
     clkB = 1;
     forever clkB = #5 ~clkB;
  end
  initial begin
     $dumpfile("wave.vcd");
     $dumpvars(1);
     #2000 $finish;
  end
endmodule
