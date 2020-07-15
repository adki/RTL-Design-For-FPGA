`timescale 1 ns / 1 ps
module top;
 initial begin
  #10; timex;
  #20.1; timex;
  #0.01; timex;
 end
 task timex;
  begin
  $display("time:     %d", $time);
  $display("stime:    %d", $stime);
  $display("realtime: %f", $realtime);
  end
 endtask
endmodule
