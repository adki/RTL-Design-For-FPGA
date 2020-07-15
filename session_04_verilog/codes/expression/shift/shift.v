module top;
   reg        [3:0] valueL, resultL, resultLS;
   reg signed [3:0] valueA, resultA, resultAS;
   initial begin
      valueL   = 4'b1000;
      resultL  = (valueL >> 2);
      resultLS = (valueL >>> 2);
      valueA   = 4'b1000;
      resultA  = (valueA >> 2);
      resultAS = (valueA >>> 2);
      //----------------------------------
      $display("valueL   : %d 0x%h", valueL, valueL);
      $display("resultL  : (valueL >> 2)  ==> %d 0x%h", resultL, resultL);
      $display("resultLS : (valueL >>> 2) ==> %d 0x%h", resultLS, resultLS);
      $display("valueA   : %d 0x%h", valueA, valueA);
      $display("resultA  : (valueA >> 2)  ==> %d 0x%h", resultA, resultA);
      $display("resultAS : (valueA >>> 2) ==> %d 0x%h", resultAS, resultAS);
   end
endmodule
