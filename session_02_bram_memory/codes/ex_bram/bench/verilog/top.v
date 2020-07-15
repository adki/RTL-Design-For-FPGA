//------------------------------------------------------------------------------
// Copyright (c) 2018 by Future Design Systems
// All right reserved
//------------------------------------------------------------------------------
// fpga.v
//------------------------------------------------------------------------------
// VERSION: 2018.03.07.
//------------------------------------------------------------------------------
`timescale 1ns/1ps

module top;
   //---------------------------------------------------------------------------
   // Oscillators
   localparam CLOCK50_FREQ =  50000000
            , CLOCK50_HALF =(1000000000/CLOCK50_FREQ/2);
   reg        osc_clk50 = 1'b0;
   always #(CLOCK50_HALF) osc_clk50 <= ~osc_clk50; // Oscillator clock 50MHz
   //---------------------------------------------------------------------------
   localparam P_DWIDTH=32
            , P_EWIDTH=(P_DWIDTH/8)
            , P_SIZE  =8*1024
            , P_DEPTH =(P_SIZE/(P_DWIDTH/8))
            , P_AWIDTH=$clog2(P_DEPTH);
   //---------------------------------------------------------------------------
   wire                  CLK = osc_clk50;
   reg   [P_AWIDTH-1:0]  ADDR={P_AWIDTH{1'b0}};
   reg                   EN  = 1'b0;
   reg   [P_EWIDTH-1:0]  WE  ={P_EWIDTH{1'b0}};
   reg   [P_DWIDTH-1:0]  DIN ={P_DWIDTH{1'b0}};
   wire  [P_DWIDTH-1:0]  DOUT;
   //---------------------------------------------------------------------------
   bram_32x8KB
   u_bram (
       .clka  ( CLK  )
     , .addra ( ADDR )
     , .ena   ( EN   )
     , .wea   ( WE   )
     , .dina  ( DIN  )
     , .douta ( DOUT )
   );
   //---------------------------------------------------------------------------
   integer arg, error, addr;
   reg [3:0] we;
   reg [P_DWIDTH-1:0] data;
   initial begin
       arg = 0;
       if ($value$plusargs("VCD=%d", arg) && arg) begin
           $dumpfile("wave.vcd");
           $dumpvars(0);
       end
       repeat (5) @ (posedge CLK);
       //-----------------------------------------------------------------------
       error = 0;
       DIN = 32'h4433_2211;
       for (addr=32'h0; addr<32'h10; addr = addr+4) begin
            we    = 4'hF;
            write(addr, we, DIN);
            read (addr,     data);
            if (DIN!==DOUT) begin
                error = error + 1;
            end
            DIN = DIN+32'h1111_1111;
            repeat (1) @ (posedge CLK);
       end
       if (error==0) $display("%m test OK");
       else          $display("%m test error");
       repeat (10) @ (posedge CLK);
       $finish(2);
   end // initial
   //---------------------------------------------------------------------------
   task write;
        input  [31:0] addr;
        input  [ 3:0] we  ;
        input  [31:0] data;
   begin
        @ (posedge CLK);
        EN    = 1'b1;
        WE    = we;
        ADDR  = addr[P_AWIDTH+1:2];
        DIN   = data;
        @ (posedge CLK);
        EN    = 1'b0;
        WE    = 4'h0;
   end
   endtask
   //---------------------------------------------------------------------------
   task read;
        input  [31:0] addr;
        output [31:0] data;
   begin
        @ (posedge CLK);
        EN   = 1'b1;
        ADDR = addr[P_AWIDTH+1:2];
        @ (posedge CLK);
        EN   = 1'b0;
        @ (posedge CLK);
        data = DOUT;
   end
   endtask
   //---------------------------------------------------------------------------
   initial begin
   end
   //---------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
// Revision history:
//
// 2018.03.07: Started by Ando Ki
//------------------------------------------------------------------------------
