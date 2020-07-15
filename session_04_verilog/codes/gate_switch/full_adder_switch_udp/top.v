// top.v
`timescale 1 ns/1 ps

module top;
  //------------------------------------------------------
  // iNCITE related one
`ifdef iNCITE
  parameter iPROVE_EIF_FILE="../incite5000/par/fpga0.eif";
`endif
  //------------------------------------------------------
    wire in1,in2,cin;
    wire sum,cout,sumr,coutr;
    reg clk,resetb;
    full_adder     Ufa(.sum(sum),
                       .cout(cout),
                       .in1(in1),
                       .in2(in2),
                       .cin(cin),
                       .clk(clk),
                       .resetb(resetb)
                   );
    stimulus       Ust(.out1(in1),
                       .out2(in2),
                       .out3(cin),
                       .clk(clk),
                       .resetb(resetb)
                   );
    full_adder_ref Urf(.sum(sumr),
                       .cout(coutr),
                       .in1(in1),
                       .in2(in2),
                       .cin(cin),
                       .clk(clk),
                       .resetb(resetb)
                   );
    checker        Uck(.in1(in1),
                       .in2(in2),
                       .cin(cin),
                       .sum(sum),
                       .cout(cout),
                       .sumr(sumr),
                       .coutr(coutr),
                       .clk(clk),
                       .resetb(resetb)
                   );
    initial begin
        clk <= 0;
        forever #5 clk <= ~clk;
    end
    initial begin
        resetb      <= 1'b0; // it should be longer than 100nsec - see GSR in glbl.v
        #200 resetb <= 1'b1;
    end
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(1);
        $dumpvars(1, Ufa);
        $dumpvars(1, Ufa.ha2.Uxor);
    end
endmodule
