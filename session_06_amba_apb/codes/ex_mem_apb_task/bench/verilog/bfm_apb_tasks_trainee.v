`ifndef BFM_APB_TASKS_V
`define BFM_APB_TASKS_V
//--------------------------------------------------------
// Copyright (c) 2020 by Ando Ki.
// All right reserved.
//
// http://www.future-ds.com
// adki@future-ds.com
//--------------------------------------------------------
// bfm_apb_tasks.h
//--------------------------------------------------------
// VERSION = 2020.07.10.
//--------------------------------------------------------
task apb_write;
input [31:0] addr;
input [31:0] data;
input [ 2:0] size;
begin

.... fill here

end
endtask
//--------------------------------------------------------
task apb_read;
input  [31:0] addr;
output [31:0] data;
input  [ 2:0] size;
begin

.... fill here

end
endtask
//--------------------------------------------------------
// It makes PSEL[P_NUM-1] signals according to PADDR[31:0].
function [P_NUM-1:0] decoder;
input [31:0] addr;
begin
    if (P_NUM>=1) begin
         if ((addr>=P_ADDR_START0)&&
             (addr<=P_ADDR_START0+P_SIZE0-1)) decoder = 1<<0;
    end
    if (P_NUM>=2) begin
         if ((addr>=P_ADDR_START1)&&
             (addr<=P_ADDR_START1+P_SIZE1-1)) decoder = 1<<1;
    end
    if (P_NUM>=3) begin
         if ((addr>=P_ADDR_START2)&&
             (addr<=P_ADDR_START2+P_SIZE2-1)) decoder = 1<<2;
    end
    if (P_NUM>=4) begin
         if ((addr>=P_ADDR_START3)&&
             (addr<=P_ADDR_START3+P_SIZE3-1)) decoder = 1<<3;
    end
    if (decoder==0) begin
         $display($time,,"%m ERROR address range.");
    end
end
endfunction
//--------------------------------------------------------
function [P_STRB-1:0] get_pstrob;
input [31:0] addr;
input [ 2:0] size;
begin
   case (addr[1:0])
   2'b00: case (size)
          3'd1: get_pstrob = 4'b0001;
          3'd2: get_pstrob = 4'b0011;
          3'd4: get_pstrob = 4'b1111;
          default: $display($time,,"%m mis-aligned access");
          endcase
   2'b01: case (size)
          3'd1: get_pstrob = 4'b0010;
          default: $display($time,,"%m mis-aligned access");
          endcase
   2'b10: case (size)
          3'd1: get_pstrob = 4'b0100;
          3'd2: get_pstrob = 4'b1100;
          default: $display($time,,"%m mis-aligned access");
          endcase
   2'b11: case (size)
          3'd1: get_pstrob = 4'b1000;
          default: $display($time,,"%m mis-aligned access");
          endcase
   endcase
end
endfunction
//--------------------------------------------------------
// It selects one of PREADY[P_NUM-1] signals according to PADDR[31:0].
function get_pready;
input [31:0] addr;
begin
    if (P_NUM>=1) begin
         if ((addr>=P_ADDR_START0)&&
             (addr<=P_ADDR_START0+P_SIZE0-1)) get_pready = PREADY[0];
    end
    if (P_NUM>=2) begin
         if ((addr>=P_ADDR_START1)&&
             (addr<=P_ADDR_START1+P_SIZE1-1)) get_pready = PREADY[1];
    end
    if (P_NUM>=3) begin
         if ((addr>=P_ADDR_START2)&&
             (addr<=P_ADDR_START2+P_SIZE2-1)) get_pready = PREADY[2];
    end
    if (P_NUM>=4) begin
         if ((addr>=P_ADDR_START3)&&
             (addr<=P_ADDR_START3+P_SIZE3-1)) get_pready = PREADY[3];
    end
end
endfunction
//--------------------------------------------------------
// It selects one of PSLVERR[P_NUM-1] signals according to PADDR[31:0].
function get_pslverr;
input [31:0] addr;
begin
    if (P_NUM>=1) begin
         if ((addr>=P_ADDR_START0)&&
             (addr<=P_ADDR_START0+P_SIZE0-1)) get_pslverr = PSLVERR[0];
    end
    if (P_NUM>=2) begin
         if ((addr>=P_ADDR_START1)&&
             (addr<=P_ADDR_START1+P_SIZE1-1)) get_pslverr = PSLVERR[1];
    end
    if (P_NUM>=3) begin
         if ((addr>=P_ADDR_START2)&&
             (addr<=P_ADDR_START2+P_SIZE2-1)) get_pslverr = PSLVERR[2];
    end
    if (P_NUM>=4) begin
         if ((addr>=P_ADDR_START3)&&
             (addr<=P_ADDR_START3+P_SIZE3-1)) get_pslverr = PSLVERR[3];
    end
end
endfunction
//--------------------------------------------------------
// It selects one of PRDATA[P_NUM-1] signals according to PADDR[31:0].
function [31:0] get_prdata;
input  [31:0] addr;
begin
    if (P_NUM>=1) begin
         if ((addr>=P_ADDR_START0)&&
             (addr<=P_ADDR_START0+P_SIZE0-1)) get_prdata = PRDATA0;
    end
    if (P_NUM>=2) begin
         if ((addr>=P_ADDR_START1)&&
             (addr<=P_ADDR_START1+P_SIZE1-1)) get_prdata = PRDATA1;
    end
    if (P_NUM>=3) begin
         if ((addr>=P_ADDR_START2)&&
             (addr<=P_ADDR_START2+P_SIZE2-1)) get_prdata = PRDATA2;
    end
    if (P_NUM>=4) begin
         if ((addr>=P_ADDR_START3)&&
             (addr<=P_ADDR_START3+P_SIZE3-1)) get_prdata = PRDATA3;
    end
end
endfunction
//--------------------------------------------------------
// Revision history
//
// 2020.07.10: Started by Ando Ki (adki@future-ds.com)
//--------------------------------------------------------
`endif
