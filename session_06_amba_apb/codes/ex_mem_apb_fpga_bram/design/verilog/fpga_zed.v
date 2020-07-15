//------------------------------------------------------------------------------
// Copyright (c) 2018 by Future Design Systems
// All right reserved
// http://www.future-ds.com
//------------------------------------------------------------------------------
// fpga.v
//------------------------------------------------------------------------------
// VERSION: 2018.03.12.
//------------------------------------------------------------------------------
`include "defines_system.v"
`include "clkmgra.v"
`include "dut.v"
`timescale 1ns/1ps

//------------------------------------------------------------------------------
module fpga
     #(parameter SL_PCLK_FREQ   =80_000_000  // SL_PCLK and SYS_CLK
               , USR_CLK_FREQ   =80_000_000  // USR_CLK for CMD/U2F/F2U-FIFO
               )
(
       input   wire          BOARD_RST_SW // U25 // synthesis xc_pulldown = 1
     , input   wire          BOARD_CLK_IN // reference clock input (66)
     //-------------------------------------------------------------------------
     , input   wire          SL_RST_N      // synthesis xc_pullup = 1
     , output  wire          SL_CS_N
     , output  wire          SL_PCLK
     , input   wire          SL_FLAGA      // synthesis xc_pulldown = 1
     , input   wire          SL_FLAGB      // synthesis xc_pulldown = 1
     , input   wire          SL_FLAGC      // synthesis xc_pulldown = 1
     , input   wire          SL_FLAGD      // synthesis xc_pulldown = 1
     , output  wire          SL_RD_N       // IF_RD
     , output  wire          SL_WR_N       // IF_WR
     , output  wire          SL_OE_N       // IF_OE
     , output  wire          SL_PKTEND_N   // IF_PKTEND
     , output  wire  [ 1:0]  SL_AD         // IF_ADDR[1:0]
     , inout   wire  [31:0]  SL_DT         // IF_DATA[31:0]
     , input   wire  [ 1:0]  SL_MODE
);
    //--------------------------------------------------------------------------
    // ZedBoard specific
    localparam BOARD_CLK_IN_FREQ=100_000_000;
    localparam FPGA_TYPE="z7"; // Zynq-7000
    localparam FPGA_FAMILY="ZYNQ7000"; // Zynq-7000
    //--------------------------------------------------------------------------
    wire SYS_CLK;
    wire SYS_CLK_STABLE;
    wire SYS_RST_N;
    wire USR_CLK;
    //--------------------------------------------------------------------------
    clkmgra #(.INPUT_CLOCK_FREQ(BOARD_CLK_IN_FREQ)
             ,.SYSCLK_FREQ     (SL_PCLK_FREQ)
             ,.CLKOUT1_FREQ    (USR_CLK_FREQ) // it does not affect for SPARTAN6
             ,.CLKOUT2_FREQ    ( 25_000_000)
             ,.CLKOUT3_FREQ    (150_000_000)
             ,.CLKOUT4_FREQ    (250_000_000)
             ,.FPGA_FAMILY     (FPGA_FAMILY))// ARTIX7, VIRTEX6, SPARTAN6
    u_clkmgr (
           .OSC_IN         ( BOARD_CLK_IN      )
         , .OSC_OUT        (  )
         , .SYS_CLK_OUT    ( SYS_CLK          )
         , .CLKOUT1        ( USR_CLK          )
         , .CLKOUT2        (  )
         , .CLKOUT3        (  )
         , .CLKOUT4        (  )
         , .SYS_CLK_LOCKED ( SYS_CLK_STABLE   )
    );
    //--------------------------------------------------------------------------
    dut
    u_dut (
           .SYS_CLK_STABLE  ( SYS_CLK_STABLE )
         , .SYS_CLK         ( SYS_CLK        )
         , .SYS_RST_N       ( SYS_RST_N      ) // SL_RST_N&SYS_CLK_STABLE
         , .SL_RST_N        ( SL_RST_N&~BOARD_RST_SW)
         , .SL_CS_N         ( SL_CS_N        )
         , .SL_PCLK         ( SL_PCLK        )
         , .SL_AD           ( SL_AD          )
         , .SL_FLAGA        ( SL_FLAGA       )
         , .SL_FLAGB        ( SL_FLAGB       )
         , .SL_FLAGC        ( SL_FLAGC       )
         , .SL_FLAGD        ( SL_FLAGD       )
         , .SL_RD_N         ( SL_RD_N        )
         , .SL_WR_N         ( SL_WR_N        )
         , .SL_OE_N         ( SL_OE_N        )
         , .SL_PKTEND_N     ( SL_PKTEND_N    )
         , .SL_DT           ( SL_DT          )
         , .SL_MODE         ( SL_MODE        )
         , .USR_CLK         ( USR_CLK        )
    );
    //--------------------------------------------------------------------------
    // synthesis translate_off
    real stamp_x, stamp_y;
    initial begin
         wait (SYS_RST_N==1'b0);
         wait (SYS_RST_N==1'b1);
         repeat (5) @ (posedge BOARD_CLK_IN);
         @ (posedge BOARD_CLK_IN); stamp_x = $realtime;
         @ (posedge BOARD_CLK_IN); stamp_y = $realtime;
         $display("%m BOARD_CLK_IN %.2f-nsec %.2f-MHz", stamp_y - stamp_x, 1000.0/(stamp_y-stamp_x));
         @ (posedge SL_PCLK); stamp_x = $realtime;
         @ (posedge SL_PCLK); stamp_y = $realtime;
         $display("%m SL_PCLK %.2f-nsec %.2f-MHz", stamp_y - stamp_x, 1000.0/(stamp_y-stamp_x));
         @ (posedge SYS_CLK); stamp_x = $realtime;
         @ (posedge SYS_CLK); stamp_y = $realtime;
         $display("%m SYS_CLK %.2f-nsec %.2f-MHz", stamp_y - stamp_x, 1000.0/(stamp_y-stamp_x));
         @ (posedge USR_CLK); stamp_x = $realtime;
         @ (posedge USR_CLK); stamp_y = $realtime;
         $display("%m USR_CLK %.2f-nsec %.2f-MHz", stamp_y - stamp_x, 1000.0/(stamp_y-stamp_x));
         $fflush();
    end
    // synthesis translate_on
    //--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
// Revision history:
//
// 2019.06.29: fpga_zed.v
// 2018.03.12: Started by Ando Ki (adki@future-ds.com)
//------------------------------------------------------------------------------
