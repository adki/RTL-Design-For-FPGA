// half_adder_beh.v
`timescale 1 ns/1 ps

module half_adder_beh(S,C,A,B);
    output S,C;
    input  A,B;
    reg    S,C;
    always @ (A or B) begin
       C <= A & B;
       S <= A ^ B;
    end
endmodule
