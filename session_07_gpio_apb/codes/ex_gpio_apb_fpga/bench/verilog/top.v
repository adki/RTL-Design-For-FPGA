//------------------------------------------------------------------------------
// Copyright (c) 2018 by Future Design Systems Co., Ltd.
// All right reserved
//
// http://www.future-ds.com
//------------------------------------------------------------------------------
// top.v
//------------------------------------------------------------------------------
// VERSION: 2018.05.14.
//------------------------------------------------------------------------------
`include "defines_system.v"
`timescale 1ns/1ps

module top;
   //---------------------------------------------------------------------------
   // Oscillators
   `ifdef BOARD_ML605
   localparam real CLOCK_FREQ =66_000_000.0;
   `elsif BOARD_SP605
   localparam real CLOCK_FREQ =27_000_000.0;
   `elsif BOARD_ZC706
   localparam real CLOCK_FREQ =156_250_000.0;
   `elsif BOARD_ZC702
   localparam real CLOCK_FREQ =156_250_000.0;
   `elsif BOARD_ZED
   localparam real CLOCK_FREQ =100_000_000.0;
   `elsif BOARD_VCU108
   localparam real CLOCK_FREQ =125_000_000.0;
   `elsif BOARD_ZCU111
   localparam real CLOCK_FREQ =100_000_000.0;
   `else
   localparam real CLOCK_FREQ =50_000_000.0;
   `endif
   localparam real CLOCK_HALF =(1_000_000_000.0/CLOCK_FREQ/2.0);
   //---------------------------------------------------------------------------
   reg        osc_clk  = 1'b0;
   always #(CLOCK_HALF) osc_clk <= ~osc_clk; // Oscillator clock 50MHz
   wire       osc_clk_p = osc_clk;
   wire       osc_clk_n =~osc_clk;
   //---------------------------------------------------------------------------
   // User reset
   reg BOARD_RST_SW=1'b1; initial #55 BOARD_RST_SW=1'b0; // active-high
   //---------------------------------------------------------------------------
   wire         #(3.5) SL_RST_N   ; PULLUP u_rst (SL_RST_N);
   wire         #(3.5) SL_PCLK    ;
   wire         #(3.5) SL_CS_N    ;
   wire         #(3.5) SL_FLAGA   ; PULLUP u_a (SL_FLAGA);
   wire         #(3.5) SL_FLAGB   ; PULLUP u_b (SL_FLAGB);
   wire         #(3.5) SL_FLAGC   ; PULLUP u_c (SL_FLAGC);
   wire         #(3.5) SL_FLAGD   ; PULLUP u_d (SL_FLAGD);
   wire         #(3.5) SL_RD_N    ; PULLUP u_r (SL_RD_N );// IF_RD
   wire         #(3.5) SL_WR_N    ; PULLUP u_w (SL_WR_N );// IF_WR
   wire         #(3.5) SL_OE_N    ; PULLUP u_o (SL_OE_N );// IF_OE
   wire         #(3.5) SL_PKTEND_N; PULLUP u_p (SL_PKTEND_N);// IF_PKTEND
   wire  [ 1:0] #(3.5) SL_MODE    ;
   wire  [ 1:0] #(3.5) SL_AD      ; // IF_ADDR[1:0]
   wire  [31:0] #(3.5) SL_DT      ; // IF_DATA[15:0]
   //---------------------------------------------------------------------------
   wire  READY;
   //---------------------------------------------------------------------------
   `ifdef TEST_CLK_MODE0 // USR_CLK(100)
          localparam USR_CLK_FREQ=100_000_000;
   `elsif TEST_CLK_MODE1 // USR_CLK(250)
          localparam USR_CLK_FREQ=250_000_000;
   `elsif TEST_CLK_MODE2 // USR_CLK( 50)
          localparam USR_CLK_FREQ= 50_000_000;
   `elsif TEST_CLK_MODE3 // USR_CLK( 30)
          localparam USR_CLK_FREQ= 30_000_000;
   `else
          localparam USR_CLK_FREQ=100_000_000;
   `endif
   //---------------------------------------------------------------------------
   wire LD0;
   wire LD1;
   wire LD2;
   wire LD3;
   wire BTNU=1'b0;
   wire BTNL=1'b0;
   wire BTNR=1'b1;
   wire BTND=1'b0;
   //---------------------------------------------------------------------------
   fpga
   u_fpga (
          .BOARD_RST_SW     ( BOARD_RST_SW )
        `ifdef BOARD_VCU108
        , .BOARD_CLK_IN_P   ( osc_clk_p   )
        , .BOARD_CLK_IN_N   ( osc_clk_n   )
        `elsif BOARD_ZC706
        , .BOARD_CLK_IN_P   ( osc_clk_p   )
        , .BOARD_CLK_IN_N   ( osc_clk_n   )
        `elsif BOARD_ZC702
        , .BOARD_CLK_IN_P   ( osc_clk_p   )
        , .BOARD_CLK_IN_N   ( osc_clk_n   )
        `elsif BOARD_ZED
        , .BOARD_CLK_IN     ( osc_clk     )
        `elsif BOARD_ZCU111
        , .BOARD_CLK_IN_P   ( osc_clk_p   )
        , .BOARD_CLK_IN_N   ( osc_clk_n   )
        `else
        , .BOARD_CLK_IN     ( osc_clk     )
        `endif
        , .SL_RST_N         ( SL_RST_N    )
        , .SL_CS_N          ( SL_CS_N     )
        , .SL_PCLK          ( SL_PCLK     )
        , .SL_FLAGA         ( SL_FLAGA    )
        , .SL_FLAGB         ( SL_FLAGB    )
        , .SL_FLAGC         ( SL_FLAGC    )
        , .SL_FLAGD         ( SL_FLAGD    )
        , .SL_RD_N          ( SL_RD_N     )
        , .SL_WR_N          ( SL_WR_N     )
        , .SL_AD            ( SL_AD       )
        , .SL_DT            ( SL_DT       )
        , .SL_OE_N          ( SL_OE_N     )
        , .SL_PKTEND_N      ( SL_PKTEND_N )
        , .SL_MODE          ( SL_MODE     )
        , .LD0  ( LD0  )
        , .LD1  ( LD1  )
        , .LD2  ( LD2  )
        , .LD3  ( LD3  )
        , .BTNU ( BTNU )
        , .BTNL ( BTNL )
        , .BTNR ( BTNR )
        , .BTND ( BTND )
   );
   //---------------------------------------------------------------------------
   gpif2slv #(.WIDTH_DT      (32)
             ,.DEPTH_FIFO_U2F(1024)
             ,.DEPTH_FIFO_F2U(1024)
             ,.NUM_WATERMARK (4))

   u_slv (
          .SL_RST_N      ( SL_RST_N    )
        , .SL_PCLK       ( SL_PCLK     )
        , .SL_CS_N       ( SL_CS_N     )
        , .SL_AD         ( SL_AD       )
        , .SL_FLAGA      ( SL_FLAGA    )
        , .SL_FLAGB      ( SL_FLAGB    )
        , .SL_FLAGC      ( SL_FLAGC    )
        , .SL_FLAGD      ( SL_FLAGD    )
        , .SL_RD_N       ( SL_RD_N     )
        , .SL_WR_N       ( SL_WR_N     )
        , .SL_DT         ( SL_DT       )
        , .SL_OE_N       ( SL_OE_N     )
        , .SL_PKTEND_N   ( SL_PKTEND_N )
        , .SL_MODE       ( SL_MODE     )
        , .READY         ( READY       )
   );
   //---------------------------------------------------------------------------
   assign  READY=u_fpga.SYS_RST_N;
   //---------------------------------------------------------------------------
   initial begin
           wait (SL_RST_N==1'b0);
           wait (SL_RST_N==1'b1);
           wait (u_slv.done==1'b1);
           repeat (30) @ (posedge SL_PCLK);
           $finish(2);
   end
   //---------------------------------------------------------------------------
    `ifdef VCD
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0);
    end
    `endif
   //---------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
// Revision history:
//
// 2018.05.14: Started by Ando Ki
//------------------------------------------------------------------------------
