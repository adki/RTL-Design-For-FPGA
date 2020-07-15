// half_adder_udp.v
`timescale 1 ns/1 ps

module half_adder_udp(S,C,A,B);
    output S,C;
    wire Cb;
    input  A,B;
    
    my_and  Unand(C,A,B);
    my_xor  Uxor (S,A,B);
endmodule
    
primitive my_and (out, in1, in2);
    output out;
    input  in1, in2;
    table
    0 0 : 0;
    0 1 : 0;
    1 0 : 0;
    1 1 : 1;
    endtable
endprimitive

primitive my_xor (out, in1, in2);
    output out;
    input  in1, in2;
    table
    0 0 : 0;
    0 1 : 1;
    1 0 : 1;
    1 1 : 0;
    endtable
endprimitive
