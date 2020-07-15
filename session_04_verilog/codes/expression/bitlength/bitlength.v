module top;
   reg [3:0] a, b;
   reg [3:0] sumA;
   reg [4:0] sumB;
   initial begin
       b = 10;
       for (a=0; a<10; a=a+1) begin
            sumA = a + b;
            $display("sumA (%d) = a (%d) + b (%d)", sumA, a, b);
            b = b + 1;
       end
       b = 10;
       for (a=0; a<10; a=a+1) begin
            sumB = a + b;
            $display("sumB (%d) = a (%d) + b (%d)", sumB, a, b);
            b = b + 1;
       end
       b = 10;
       for (a=0; a<10; a=a+1) begin
            sumA = (a + b)>>1;
            sumB = (a + b)>>1;
            $display("sumA (%d) = (a (%d) + b (%d)) >> 1; %d", sumA, a, b, sumB);
            b = b + 1;
       end
   end
endmodule
