// half_adder_rtl.v
`timescale 1 ns/1 ps

module half_adder_rtl(S,C,A,B);
    output S,C;
    input  A,B;
    wire   S,C;
    assign C = A & B;
    assign S = A ^ B;
endmodule
