module top;
  integer count;
  initial begin
    count = 10;
    while (count>0) begin
       $display("%d count down", count);
       count = count - 1;
    end
  end
endmodule
