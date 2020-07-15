// stimulus.v
`timescale 1ns/1ps

module stimulus(out1,out2,out3,clk);
    output out1,out2,out3;
    input clk;
    reg out1,out2,out3;
    initial begin
        out1=0;out2=0;out3=0;
        #10;      out1=1;out2=0;out3=0;
        #10;      out1=0;out2=1;out3=0;
        #10;      out1=1;out2=1;out3=0;
        #10;      out1=0;out2=0;out3=1;
        #10;      out1=1;out2=0;out3=1;
        #10;      out1=0;out2=1;out3=1;
        #10;      out1=1;out2=1;out3=1;
        #10;
        $finish;
    end
endmodule
