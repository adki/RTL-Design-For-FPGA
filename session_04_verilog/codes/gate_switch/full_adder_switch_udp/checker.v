// checker.v
`timescale 1 ns/1 ps

module checker(in1,in2,cin,sum,cout,sumr,coutr,clk,resetb);
    input in1,in2,cin,sum,cout,sumr,coutr,clk,resetb;
    always @ (clk) begin
        if ({cout,sum}=={coutr,sumr})
                 $display($time,,"correct");
        else $display($time,,"error result=%b expect=%b",
                             {cout, sum}, {coutr,sumr});
    end
endmodule
