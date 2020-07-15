// full_adder.v

`timescale 1ns/1ps

module full_adder(sum,carry,A,B,C);
    output sum, carry;
    input  A, B, C;

    //sum_udp   Dsum   (.SUM(sum),     .A(A), .B(B), .C(C));
    sum_udp   Dsum   (sum, A, B, C);
    //carry_udp Dcaary (.CARRY(carry), .A(A), .B(B), .C(C));
    carry_udp Dcarry (carry, A, B, C);
endmodule

primitive sum_udp (SUM, A, B, C);
    output SUM;
    input  A, B, C;
    table
    0 0 0: 0;
    0 0 1: 1;
    0 1 0: 1;
    0 1 1: 0;
    1 0 0: 1;
    1 0 1: 0;
    1 1 0: 0;
    1 1 1: 1;
    endtable
endprimitive

primitive carry_udp (CARRY, A, B, C);
    output CARRY;
    input  A, B, C;
    table
    0 0 0: 0;
    0 0 1: 0;
    0 1 0: 0;
    0 1 1: 1;
    1 0 0: 0;
    1 0 1: 1;
    1 1 0: 1;
    1 1 1: 1;
    endtable
endprimitive
