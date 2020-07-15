`timescale 1ns/1ns
module top;
   parameter AW=8, DW=8;
   reg  [AW-1:0] add;
   reg  [DW-1:0] datw;
   wire [DW-1:0] datrA, datrB;
   wire [3:0]    datrC;
   reg           en, we;
   reg           clk, rstb;
   integer x;
   //---------------------------------------------
   mem_generic          UA (add, datrA, datw, en, we, clk, rstb);
   mem_generic #(8,8,2) UB (add, datrB, datw, en, we, clk, rstb);
   mem_generic #(5,4,5) UC (add[4:0], datrC[3:0], datw[3:0], en, we, clk, rstb);
   //---------------------------------------------
   always @ (*) #5 clk <= ~clk;
   initial begin
       add  <= {AW{1'b0}};
       datw <= {DW{1'b0}};
       en   <= 1'b0; we   <= 1'b0;
       clk  <= 1'b0; rstb <= 1'b1;
       #33 rstb <= 1'b0;
       #50 rstb <= 1'b1;
   end
   //---------------------------------------------
   initial begin
      wait(rstb==1'b0);
      wait(rstb==1'b1);
      repeat (2) @ (posedge clk);
      for (x=0; x<8; x=x+1) begin
           add  <= x;
           datw <= x+11;
           en   <= 1'b1;
           we   <= 1'b1;
           @ (posedge clk);
           en   <= 1'b0;
           we   <= 1'b0;
           repeat (2) @ (posedge clk);
      end
      for (x=0; x<8; x=x+1) begin
           add  <= x;
           en   <= 1'b1;
           @ (posedge clk);
           en   <= 1'b0;
           repeat (2) @ (posedge clk);
      end
      repeat (2) @ (posedge clk);
      $finish;
   end
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(1);
    end
endmodule
