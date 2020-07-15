// checker.v
`timescale 1ns/1ps

module checker(in1,in2,cin,sum,cout,clk);
    input in1,in2,cin,sum,cout,clk;
    reg[1:0] result;
    always@(posedge clk)begin
        result=in1+in2+cin;
        if(result != {cout,sum})
              $display($time,,"error");
              else $display($time,,"correct");
          end
  endmodule
