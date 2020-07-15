module top;
  integer count;
  initial begin
    count = 10;
    for (count=10; count>0; count=count-1) begin
       $display("%d count down", count);
    end
  end
endmodule
