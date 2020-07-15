module top;
  integer count;
  initial begin
    count = 10;
    repeat (count) begin
       $display("%d count down", count);
       count = count - 1;
    end
  end
  // The loop will execute 10 times regardless
  // of whether the value of count changes after
  // entry to the loop.
endmodule
