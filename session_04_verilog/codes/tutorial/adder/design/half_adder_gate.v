// half_adder_gate.v
`timescale 1 ns/1 ps

module half_adder_gate(S,C,A,B);
    output S,C;
    input  A,B;
    and UAND(C,A,B);
    xor UXOR(S,A,B);
endmodule
