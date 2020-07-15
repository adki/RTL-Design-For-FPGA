`timescale 1ns/1ns
module mem_generic(add, datr, datw, en, we, clk, rstb);
   parameter ADD_WIDTH=8, DAT_WIDTH=8;
   parameter DELAY=0;
   //-------------------------------------------------
   input  [ADD_WIDTH-1:0] add;  wire [ADD_WIDTH-1:0] add; 
   output [DAT_WIDTH-1:0] datr; reg  [DAT_WIDTH-1:0] datr;
   input  [DAT_WIDTH-1:0] datw; wire [DAT_WIDTH-1:0] datw;
   input                  en;   wire                 en;
   input                  we;   wire                 we;
   input                  clk;  wire                 clk;
   input                  rstb; wire                 rstb;
   //-------------------------------------------------
   localparam DEPTH = 1<<ADD_WIDTH;
   //-------------------------------------------------
   reg [DAT_WIDTH-1:0] mem[0:DEPTH-1];
   //-------------------------------------------------
   always @ (posedge clk or negedge rstb) begin
      if (rstb==1'b0) begin
          datr  <= {DAT_WIDTH{1'b0}};
      end else begin
          if (en==1'b1) begin
             if (we==1'b1) begin
                datr     <= #(DELAY) datw;
                mem[add] <= datw;
             end else begin
                datr     <= #(DELAY) mem[add];
             end
          end
      end
   end
endmodule
