//--------------------------------------------------------
// Copyright (c) 2020 by Ando Ki.
// All right reserved.
//
// http://www.future-ds.com
// adki@future-ds.com
//--------------------------------------------------------
// mem_apb.v
//--------------------------------------------------------
// VERSION: 2020.07.10.
//--------------------------------------------------------
// Simplified memory with AMBA APB
//--------------------------------------------------------
`define AMBA_APB3
`timescale 1ns/1ns

module mem_apb #(parameter SIZE_IN_BYTES=1024)
(
       input   wire          PRESETn
     , input   wire          PCLK
     , input   wire          PSEL
     , input   wire          PENABLE
     , input   wire  [31:0]  PADDR
     , input   wire          PWRITE
     , output  wire  [31:0]  PRDATA
     , input   wire  [31:0]  PWDATA
     //-----------------------------------------------------------
     `ifdef AMBA_APB3
     , output  wire          PREADY
     , output  wire          PSLVERR
     `endif
     `ifdef AMBA_APB4
     , input   wire  [ 3:0]  PSTRB
     , input   wire  [ 2:0]  PPROT
     `endif
);
   //-----------------------------------------------------
   `ifdef AMBA_APB3
    assign PREADY   = 1'b1;
    assign PSLVERR  = 1'b0;
   `endif
   `ifndef AMBA_APB4
    wire  [3:0]  PSTRB = 4'hF;
   `endif
   //-----------------------------------------------------
   localparam AW = clogb2(SIZE_IN_BYTES);
   localparam DEPTH = SIZE_IN_BYTES/4;
   reg [7:0] mem0[0:DEPTH-1];// synthesis syn_ramstyle="block_ram"; 
   reg [7:0] mem1[0:DEPTH-1];// synthesis syn_ramstyle="block_ram";
   reg [7:0] mem2[0:DEPTH-1];// synthesis syn_ramstyle="block_ram";
   reg [7:0] mem3[0:DEPTH-1];// synthesis syn_ramstyle="block_ram";
   //-----------------------------------------------------
   wire [AW-1:0] TA = PADDR[AW+1:2];
   //-----------------------------------------------------
   // write
   //             ____      ____      ____
   // PCLK    ___|    |____|    |____|    |_
   //         ____ ___________________ _____
   // PADDR   ____X__A________________X_____
   //         ____ ___________________ _____
   // PWDATA  ____X__DW_______________X_____
   //              ___________________
   // PWRITE  ____|                   |_____
   //              ___________________
   // PSEL    ____|                   |_____
   //                        _________
   // PENABLE ______________|         |_____
   //
   always @ (posedge PCLK or negedge PRESETn) begin
   if (PRESETn==1'b0) begin
   end else begin
        if (PSEL & PENABLE & PWRITE & PSTRB[0]) mem0[TA] <= PWDATA[ 7: 0];
        if (PSEL & PENABLE & PWRITE & PSTRB[1]) mem1[TA] <= PWDATA[15: 8];
        if (PSEL & PENABLE & PWRITE & PSTRB[2]) mem2[TA] <= PWDATA[23:16];
        if (PSEL & PENABLE & PWRITE & PSTRB[3]) mem3[TA] <= PWDATA[31:24];
   end // if
   end // always
   //-----------------------------------------------------
   // read
   //             ____      ____      ____
   // PCLK    ___|    |____|    |____|    |_
   //         ____ ___________________ _____
   // PADDR   ____X__A________________X_____
   //         ____           _________ _____
   // PRDATA  ____XXXXXXXXXXX__DR_____X_____
   //         ____                     _____
   // PWRITE  ____|___________________|_____
   //              ___________________
   // PSEL    ____|                   |_____
   //                        _________
   // PENABLE ______________|         |_____
   //
   assign PRDATA = (PRESETn & PSEL & ~PWRITE)
                 ? {mem3[TA],mem2[TA],mem1[TA],mem0[TA]}
                 : ~32'h0;
   //-----------------------------------------------------
   // synopsys translate_off
   integer i;
   initial begin
           for (i=0; i<DEPTH; i=i+1) begin
               mem0[i] = ~32'h0;
               mem1[i] = ~32'h0;
               mem2[i] = ~32'h0;
               mem3[i] = ~32'h0;
           end
   end
   `ifdef RIGOR
   always @ (posedge PCLK or negedge PRESETn) begin
        if (PRESETn==1'b0) begin
        end else begin
             if (PSEL & PENABLE) begin
                 if (TA>=DEPTH) $display($time,,"%m: ERROR: out-of-bound 0x%x",
                                                 PADDR);
             end
        end
   end
   `endif
   // synopsys translate_on
   //-----------------------------------------------------
    function integer clogb2;
    input [31:0] value;
    reg   [31:0] tmp, rt;
    begin
          tmp = value - 1;
          for (rt=0; tmp>0; rt=rt+1) tmp=tmp>>1;
          clogb2 = rt;
    end
    endfunction
endmodule
//--------------------------------------------------------
// Revision History:
//
// 2020.07.10: Started by Ando Ki
//             APB3 and APB4 feature added by Ando Ki.
// http://www.future-ds.com
// adki@future-ds.com
//--------------------------------------------------------
