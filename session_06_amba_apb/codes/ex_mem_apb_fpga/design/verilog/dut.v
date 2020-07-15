//------------------------------------------------------------------------------
// Copyright (c) 2020 by Future Design Systems.
// All right reserved.
//------------------------------------------------------------------------------
// dut.v
//------------------------------------------------------------------------------
// VERSION: 2020.07.10.
//------------------------------------------------------------------------------
//         +----------+        +----------+
//         |          |<======>| mem_apb  |
//         |          |        +----------+
//         |          |        +----------+
//         |          |<======>| mem_apb  |
//  ======>|bfm_apb   |        +----------+
//         |          |        +----------+
//         |          |<======>| mem_apb  |
//         |          |        +----------+
//         |          |        +----------+
//         |          |<======>| mem_apb  |
//         +--------- +        +----------+
//------------------------------------------------------------------------------

module dut
(
     input  wire                SYS_CLK_STABLE
   , input  wire                SYS_CLK   // master clock and goes to SL_PCLK
   , output wire                SYS_RST_N // by-pass of SL_RST_N
   , input  wire                SL_RST_N
   , output wire                SL_CS_N
   , output wire                SL_PCLK   // by-pass of SYS_CLK after phase shift
   , output wire [ 1:0]         SL_AD
   , input  wire                SL_FLAGA // active-low empty (U2F)
   , input  wire                SL_FLAGB // active-low almost-empty
   , input  wire                SL_FLAGC // active-low full (F2U)
   , input  wire                SL_FLAGD // active-low almost-full
   , output wire                SL_RD_N
   , output wire                SL_WR_N
   , output wire                SL_OE_N // when low, let FX3 drive data through SL_DT_I
   , output wire                SL_PKTEND_N
   , inout  wire [31:0]         SL_DT
   , input  wire [ 1:0]         SL_MODE
   , input  wire                USR_CLK
);
   //---------------------------------------------------------------------------
   localparam NUM_PSLAVE=4;
   //---------------------------------------------------------------------------
   (* mark_debug="true" *) wire                     PRESETn=SYS_RST_N;
   (* mark_debug="true" *) wire                     PCLK=USR_CLK;
   (* mark_debug="true" *) wire [31:0]              S_PADDR;
   (* mark_debug="true" *) wire                     S_PENABLE;
   (* mark_debug="true" *) wire                     S_PWRITE;
   (* mark_debug="true" *) wire [31:0]              S_PWDATA;
   (* mark_debug="true" *) wire [NUM_PSLAVE-1:0]    S_PSEL;
   (* mark_debug="true" *) wire [31:0]              S_PRDATA[0:NUM_PSLAVE-1];
                           `ifdef AMBA_APB3
   (* mark_debug="true" *) wire [NUM_PSLAVE-1:0]    S_PREADY;
   (* mark_debug="true" *) wire [NUM_PSLAVE-1:0]    S_PSLVERR;
                           `endif
                           `ifdef AMBA_APB4
   (* mark_debug="true" *) wire [ 3:0]              S_PSTRB;
   (* mark_debug="true" *) wire [ 2:0]              S_PPROT;
                           `endif
   (* mark_debug="true" *) wire [31:0]              S0_PRDATA=S_PRDATA[0];
   (* mark_debug="true" *) wire [31:0]              S1_PRDATA=S_PRDATA[1];
   (* mark_debug="true" *) wire [31:0]              S2_PRDATA=S_PRDATA[2];
   (* mark_debug="true" *) wire [31:0]              S3_PRDATA=S_PRDATA[3];
   //---------------------------------------------------------------------------
   wire [15:0] GPOUT;
   //---------------------------------------------------------------------------
   bfm_apb_s4
   u_bfm_apb (
          .SYS_CLK_STABLE  ( SYS_CLK_STABLE )
        , .SYS_CLK         ( SYS_CLK        )
        , .SYS_RST_N       ( SYS_RST_N      )
        , .SL_RST_N        ( SL_RST_N       )
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
        , .PRESETn         ( PRESETn        )
        , .PCLK            ( PCLK           )
        , .S_PADDR         ( S_PADDR        )
        , .S_PENABLE       ( S_PENABLE      )
        , .S_PWRITE        ( S_PWRITE       )
        , .S_PWDATA        ( S_PWDATA       )
        , .S0_PSEL         ( S_PSEL      [0])
        , .S0_PRDATA       ( S_PRDATA    [0])
        `ifdef AMBA_APB3
        , .S0_PREADY       ( S_PREADY    [0])
        , .S0_PSLVERR      ( S_PSLVERR   [0])
        `endif
        , .S1_PSEL         ( S_PSEL      [1])
        , .S1_PRDATA       ( S_PRDATA    [1])
        `ifdef AMBA_APB3
        , .S1_PREADY       ( S_PREADY    [1])
        , .S1_PSLVERR      ( S_PSLVERR   [1])
        `endif
        , .S2_PSEL         ( S_PSEL      [2])
        , .S2_PRDATA       ( S_PRDATA    [2])
        `ifdef AMBA_APB3
        , .S2_PREADY       ( S_PREADY    [2])
        , .S2_PSLVERR      ( S_PSLVERR   [2])
        `endif
        , .S3_PSEL         ( S_PSEL      [3])
        , .S3_PRDATA       ( S_PRDATA    [3])
        `ifdef AMBA_APB3
        , .S3_PREADY       ( S_PREADY    [3])
        , .S3_PSLVERR      ( S_PSLVERR   [3])
        `endif
        `ifdef AMBA_APB4
        , .S_PSTRB         ( S_PSTRB      )
        , .S_PPROT         ( S_PPROT      )
        `endif
        , .IRQ             ( GPOUT[0]     )
        , .FIQ             ( GPOUT[1]     )
        , .GPOUT           ( GPOUT        )
        , .GPIN            ( GPOUT        )
   );
   //---------------------------------------------------------------------------
   genvar idx;
   generate
   for (idx=0; idx<NUM_PSLAVE; idx=idx+1) begin : BLK_IDX
        mem_apb #(.SIZE_IN_BYTES(1024))
        u_mem_apb (
              .PRESETn   (PRESETn         )
            , .PCLK      (PCLK            )
            , .PSEL      (S_PSEL     [idx])
            , .PADDR     (S_PADDR         )
            , .PENABLE   (S_PENABLE       )
            , .PWRITE    (S_PWRITE        )
            , .PWDATA    (S_PWDATA        )
            , .PRDATA    (S_PRDATA   [idx])
            `ifdef AMBA_APB3
            , .PREADY    (S_PREADY   [idx])
            , .PSLVERR   (S_PSLVERR  [idx])
            `endif
            `ifdef AMBA_APB4
            , .PPROT     (S_PPROT         )
            , .PSTRB     (S_PSTRB         )
            `endif
        );
   end // for
   endgenerate
   //---------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
// Revision History
//
// 2020.07.10: Started by Ando Ki (adki@future-ds.com)
//------------------------------------------------------------------------------
