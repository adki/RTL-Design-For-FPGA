module top;
  integer           intA, intB, intC, intD;
  reg        [15:0] regA, regB, regC;
  reg signed [15:0] regSA, regSB;

  initial begin
     intA = -12 / 3;      // The result is -4.
     intB = -'d 12 / 3;   // The result is 1431655761.
     intC = -'sd 12 / 3;  // The result is -4.
     intD = -4'sd 12 / 3; // -4'sd12 is the negative of the 4-bit
                          // quantity 1100, which is -4. -(-4) = 4.
                          // The result is 1.
     $display("intA : -12 / 3      => %d 0x%h", intA, intA);
     $display("intB : -'d 12 / 3   => %d 0x%h", intB, intB);
     $display("intC : -'sd 12 / 3  => %d 0x%h", intC, intC);
     $display("intD : -4'sd 12 / 3 => %d 0x%h", intD, intD);
     //-----------------------------------------------------
     intA = -4'd12;   // intA will be unsigned FFFFFFF4
     regA = intA / 3; // expression result is -4,
                      // intA is an integer data type, regA is 65532
     regB = -4'd12;   // regB is 65524
     intB = regB / 3; // expression result is 21841,
                      // regB is a reg data type
     intC = -4'd12 / 3; // expression result is 1431655761.
                        // -4'd12 is effectively a 32-bit reg data type
     regC = -12 / 3; // expression result is -4, -12 is effectively
                     // an integer data type. regC is 65532
     regSA = -12 / 3;     // expression result is -4. regSA is a signed reg
     regSB = -4'sd12 / 3; // expression result is 1. -4'sd12 is actually 4.

     $display("intA  : -4'd12      => %d 0x%h", intA, intA);
     $display("regA  : intA / 3    => %d 0x%h", regA, regA);
     $display("regB  : -4'd12      => %d 0x%h", regB, regB);
     $display("intB  : regB / 3    => %d 0x%h", intB, intB);
     $display("intC  : -4'd12 / 3  => %d 0x%h", intC, intC);
     $display("regC  : -12 / 3     => %d 0x%h", regC, regC);
     $display("regSA : -12 / 3     => %d 0x%h", regSA, regSA);
     $display("regSB : -4'sd12 / 3 => %d 0x%h", regSB, regSB);
  end
endmodule
