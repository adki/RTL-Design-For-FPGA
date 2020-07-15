// half_adder_switch.v
`timescale 1 ns/1 ps

module half_adder_switch(S, C, A, B);
    output S,C;
    input  A,B;
    
    and_sw  Unand(C, A, B);
    xor_sw  Uxor (S,A,B);
    
endmodule

module and_sw(out,A,B);
    output out;
    input  A,B;
    wire   ob, y;

    supply1 vdd;
    supply0 gnd;
    
    pmos Upmos1(ob, vdd, A);
    pmos Upmos2(ob, vdd, B);
    nmos Unmos1(ob, y,   A);
    nmos Unmos2(y,  gnd, B);

    pmos Upmos(out,vdd,ob);
    nmos Unmos(out,gnd,ob);
endmodule

module xor_sw(out,A,B);
      output out;
      input  A,B;
      wire   Ab, Bb;
      wire   w, x, y, z;

      supply1 vdd;
      supply0 gnd;

      // ~A
      pmos Up11 (Ab, vdd, A);
      nmos Un12 (Ab, gnd, A);
      // ~B
      pmos Up21 (Bb, vdd, B);
      nmos Un22 (Bb, gnd, B);

      // pull-up network
      pmos Up31 (x, vdd, Ab);
      pmos Up42 (x, vdd, Bb);
      pmos Up41 (y, x,   A);
      pmos Up32 (y, x,   B);

      // pull-down network
      nmos Un61 (y, w,   Ab);
      nmos Un52 (w, gnd, Bb);
      nmos Un51 (y, z,   A);
      nmos Un62 (z, gnd, B);

      // output
      cmos Uc (out, y, vdd, gnd);
endmodule
