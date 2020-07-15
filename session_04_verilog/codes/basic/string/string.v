module top;
   reg [8*14:1] stringvar;
   reg [8*5:1]  shortvar;
   initial begin
      stringvar = "Hello world";
      $display("%s is stored as %h", stringvar,stringvar);
      stringvar = {stringvar,"!!!"};
      $display("%s is stored as %h", stringvar,stringvar);
      shortvar = "Hello world";
      $display("%s is stored as %h", shortvar,shortvar);
   end
endmodule
