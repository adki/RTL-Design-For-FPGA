// stimulus.v
`timescale 1 ns/1 ps

module stimulus(out1,out2,out3,clk,resetb);
    output out1,out2,out3;
    input clk,resetb;
    reg out1,out2,out3;
    initial begin
        out1 <=0; out2 <=0; out3 <=0;
        wait (resetb==1'b0);
        wait (resetb==1'b1); @ (posedge clk);
        out1=1; out2=0; out3=0; @ (posedge clk);
        out1=0; out2=1; out3=0; @ (posedge clk);
        out1=1; out2=1; out3=0; @ (posedge clk);
        out1=0; out2=0; out3=1; @ (posedge clk);
        out1=1; out2=0; out3=1; @ (posedge clk);
        out1=0; out2=1; out3=1; @ (posedge clk);
        out1=1; out2=1; out3=1; @ (posedge clk);
        repeat (3) @ (posedge clk);
        $finish;
    end
endmodule
