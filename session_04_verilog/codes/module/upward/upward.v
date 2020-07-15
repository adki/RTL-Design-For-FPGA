module top;
  a u_a();
  d u_d();
  initial begin // full path name references each copy of i
    u_a.i = 1;           u_d.i = 5;
    u_a.a_b1.i = 2;      u_d.d_b1.i = 6;
    u_a.a_b1.b_c1.i = 3; u_d.d_b1.b_c1.i = 7;
    u_a.a_b1.b_c2.i = 4; u_d.d_b1.b_c2.i = 8;
  end
endmodule

module a;
   integer i;
   b a_b1();
endmodule

module b;
   integer i;
   c b_c1();
   c b_c2();
   initial begin
      #10 b_c1.i = 2; // downward path references two copies of i
                      // a.a_b1.b_c1.i, d.d_b1.b_c1.i
      //#10 a.i = 3;  // upward reference - ambiguous
      //#10 d.i = 3;  // upward reference - ambiguous
   end
endmodule

module c;
   integer i;
   initial begin
      i = 1; // local name references four copies of i
             // a.a_b1.b_c1.i, a.a_b1.b_c2.i,
             // d.d_b1.b_c1.i, d.d_b1.b_c2.i
      b.i = 1; // upward path references two copies of i
               // a.a_b1.i, d.d_b1.i
   end
endmodule

module d;
  integer i;
  b d_b1();
  initial begin // full path name references each copy of i
    i = 5;
    d_b1.i = 6;
    d_b1.b_c1.i = 7;
    d_b1.b_c2.i = 8;
    d.i = 9;
    d.d_b1.i = 10;
    d.d_b1.b_c1.i = 11;
    d.d_b1.b_c2.i = 12;
  end
endmodule
