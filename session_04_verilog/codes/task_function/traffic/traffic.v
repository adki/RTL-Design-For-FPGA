module top;
  reg clk, resetb;
  initial begin
      clk  = 0;
      resetb = 0; #15;
      resetb = 1; #15;
      repeat (300) @ (posedge clk);
      $finish;
  end
  always #5 clk <= ~clk;
  traffic_lights Utr (.clk(clk), .resetb(resetb));
  initial begin
        $dumpfile("wave.vcd");
        $dumpvars(1);
        $dumpvars(1, Utr);
  end
endmodule

module traffic_lights(clk, resetb);
   input clk, resetb;
   reg   red, amber, green;
   parameter on = 1, off = 0, red_tics = 30,
             amber_tics = 10, green_tics = 20;
   // initialize colors.
   initial red   = off;
   initial amber = off;
   initial green = off;
   always @ (clk or resetb) begin // sequence to control the lights.
       if (resetb==1'b1) begin
          red = on; // turn red light on
          light(red, red_tics); // and wait.
          amber = on; // turn amber light on
          light(amber, amber_tics); // and wait.
          green = on; // turn green light on
          light(green, green_tics); // and wait.
          amber = on; // turn amber light on
          light(amber, amber_tics); // and wait.
       end
   end
   
   // task to wait for 'tics' positive edge clocks
   // before turning 'color' light off.
   task light;
      output color;
      input [31:0] tics;
      begin
          repeat (tics) @ (posedge clk);
          color = off; // turn light off.
      end
   endtask
endmodule
