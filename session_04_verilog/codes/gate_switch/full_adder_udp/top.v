// top.v
`timescale 1ns/1ps

module top;
    wire sum,cout,in1,in2,cin;
    reg clk;
    full_adder fa(.sum(sum),.carry(cout),.A(in1),.B(in2),.C(cin));
    stimulus   st(.out1(in1),.out2(in2),.out3(cin),.clk(clk));
    checker    ck(.in1(in1),.in2(in2),.cin(cin),.sum(sum),.cout(cout),.clk(clk));
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(1,sum);
        $dumpvars(1,cout);
        $dumpvars(1,in1);
        $dumpvars(1,in2);
        $dumpvars(1,cin);
        $dumpvars(1,clk);
    end
endmodule
