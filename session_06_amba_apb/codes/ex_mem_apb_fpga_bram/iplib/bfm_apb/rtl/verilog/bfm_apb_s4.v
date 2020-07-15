//------------------------------------------------------------------------------
// Copyright (c) 2020 by Future Design Systems.
// All right reserved.
//------------------------------------------------------------------------------
// dut.v
//------------------------------------------------------------------------------
// VERSION: 2020.07.10.
//------------------------------------------------------------------------------
//  +---------+        +----------+        +----------+
//  |         |        |          |<======>| mem_apb  |
//  |         |        |          |        +----------+
//  |         |        |          |        +----------+
//  |         |        |          |<======>| mem_apb  |
//  | bfm_axi |<======>|axi2apb   |        +----------+
//  |         |        |          |        +----------+
//  |         |        |          |<======>| mem_apb  |
//  |         |        |          |        +----------+
//  |         |        |          |        +----------+
//  |         |        |          |<======>| mem_apb  |
//  +---------+        +--------- +        +----------+
//------------------------------------------------------------------------------
`include "axi_to_apb_s4.v"

module bfm_apb_s4
     #(parameter ADDR_PBASE0=32'h0000_0000, ADDR_PLENGTH0=16
               , ADDR_PBASE1=32'h0001_0000, ADDR_PLENGTH1=16
               , ADDR_PBASE2=32'h0002_0000, ADDR_PLENGTH2=16
               , ADDR_PBASE3=32'h0003_0000, ADDR_PLENGTH3=16
               , NUM_PSLAVE=4
               , WIDTH_PAD =32 // address width
               , WIDTH_PDA =32 // data width
               , WIDTH_PDS =(WIDTH_PDA/8))// data strobe width
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
   //---------------------------------------------------------------------------
   , input  wire                     PRESETn
   , input  wire                     PCLK
   , output wire [WIDTH_PAD-1:0]     S_PADDR
   , output wire                     S_PENABLE
   , output wire                     S_PWRITE
   , output wire [WIDTH_PDA-1:0]     S_PWDATA
   , output wire                     S0_PSEL
   , output wire                     S1_PSEL
   , output wire                     S2_PSEL
   , output wire                     S3_PSEL
   , input  wire [WIDTH_PDA-1:0]     S0_PRDATA
   , input  wire [WIDTH_PDA-1:0]     S1_PRDATA
   , input  wire [WIDTH_PDA-1:0]     S2_PRDATA
   , input  wire [WIDTH_PDA-1:0]     S3_PRDATA
   `ifdef AMBA_APB3
   , input  wire                     S0_PREADY
   , input  wire                     S1_PREADY
   , input  wire                     S2_PREADY
   , input  wire                     S3_PREADY
   , input  wire                     S0_PSLVERR
   , input  wire                     S1_PSLVERR
   , input  wire                     S2_PSLVERR
   , input  wire                     S3_PSLVERR
   `endif
   `ifdef AMBA_APB4
   , output wire [WIDTH_PDS-1:0]     S_PSTRB
   , output wire [ 2:0]              S_PPROT
   `endif
   , input  wire                     IRQ
   , input  wire                     FIQ
   , input  wire [15:0]              GPIN
   , output wire [15:0]              GPOUT
);
   //---------------------------------------------------------------------------
   // synthesis attribute IOB of SL_DT is "TRUE";
   wire [31:0]  SL_DT_I;
   wire [31:0]  SL_DT_O;
   wire         SL_DT_T;
   assign SL_DT_I = SL_DT;
   assign SL_DT   = (SL_DT_T==1'b0) ? SL_DT_O : 32'hZ;
   //---------------------------------------------------------------------------
   parameter AXI_MST_ID   = 1;
   parameter AXI_WIDTH_CID= 4 // Channel ID width in bits
           , AXI_WIDTH_ID = 4 // ID width in bits
           , AXI_WIDTH_AD =32 // address width
           , AXI_WIDTH_DA =32 // data width
           , AXI_WIDTH_DS =(AXI_WIDTH_DA/8)  // data strobe width
           , AXI_WIDTH_SID=(AXI_WIDTH_CID+AXI_WIDTH_ID);
   //--------------------------------------------
   wire                     BFM_ARESETn=PRESETn;
   wire                     BFM_ACLK   =PCLK;
   wire [AXI_WIDTH_CID-1:0] BFM_MID    =AXI_MST_ID; // Master(BFM) drives its channel id
   wire [AXI_WIDTH_ID-1:0]  BFM_AWID   ; // note NOT AXI_WIDTH_SID
   wire [AXI_WIDTH_AD-1:0]  BFM_AWADDR;
   `ifdef AMBA_AXI4
   wire [ 7:0]              BFM_AWLEN;
   wire                     BFM_AWLOCK;
   `else
   wire [ 3:0]              BFM_AWLEN;
   wire [ 1:0]              BFM_AWLOCK;
   `endif
   wire [ 2:0]              BFM_AWSIZE;
   wire [ 1:0]              BFM_AWBURST;
   `ifdef AMBA_AXI_CACHE
   wire [ 3:0]              BFM_AWCACHE;
   `endif
   `ifdef AMBA_AXI_PROT
   wire [ 2:0]              BFM_AWPROT;
   `endif
   wire                     BFM_AWVALID;
   wire                     BFM_AWREADY;
   `ifdef AMBA_AXI4
   wire [ 3:0]              BFM_AWQOS;
   wire [ 3:0]              BFM_AWREGION;
   `endif
   wire [AXI_WIDTH_ID-1:0]  BFM_WID;
   wire [AXI_WIDTH_DA-1:0]  BFM_WDATA;
   wire [AXI_WIDTH_DS-1:0]  BFM_WSTRB;
   wire                     BFM_WLAST;
   wire                     BFM_WVALID;
   wire                     BFM_WREADY;
   wire [AXI_WIDTH_SID-1:0] BFM_BID;
   wire [ 1:0]              BFM_BRESP;
   wire                     BFM_BVALID;
   wire                     BFM_BREADY;
   wire [AXI_WIDTH_ID-1:0]  BFM_ARID;
   wire [AXI_WIDTH_AD-1:0]  BFM_ARADDR;
   `ifdef AMBA_AXI4
   wire [ 7:0]              BFM_ARLEN;
   wire                     BFM_ARLOCK;
   `else
   wire [ 3:0]              BFM_ARLEN;
   wire [ 1:0]              BFM_ARLOCK;
   `endif
   wire [ 2:0]              BFM_ARSIZE;
   wire [ 1:0]              BFM_ARBURST;
   `ifdef AMBA_AXI_CACHE
   wire [ 3:0]              BFM_ARCACHE;
   `endif
   `ifdef AMBA_AXI_PROT
   wire [ 2:0]              BFM_ARPROT;
   `endif
   wire                     BFM_ARVALID;
   wire                     BFM_ARREADY;
   `ifdef AMBA_AXI4
   wire [ 3:0]              BFM_ARQOS;
   wire [ 3:0]              BFM_ARREGION;
   `endif
   wire [AXI_WIDTH_SID-1:0] BFM_RID;
   wire [AXI_WIDTH_DA-1:0]  BFM_RDATA;
   wire [ 1:0]              BFM_RRESP;
   wire                     BFM_RLAST;
   wire                     BFM_RVALID;
   wire                     BFM_RREADY;
   //---------------------------------------------------------------------------
   bfm_axi
   u_bfm_axi (
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
        , .SL_DT_I         ( SL_DT_I        )
        , .SL_DT_O         ( SL_DT_O        )
        , .SL_DT_T         ( SL_DT_T        )
        , .SL_MODE         ( SL_MODE        )
        , .ARESETn  ( BFM_ARESETn  )
        , .ACLK     ( BFM_ACLK     )
        , .MID      ( BFM_MID      )
        , .AWID     ( BFM_AWID     ) //[AXI_WIDTH_ID-1:0]
        , .AWADDR   ( BFM_AWADDR   )
        , .AWLEN    ( BFM_AWLEN    )
        , .AWLOCK   ( BFM_AWLOCK   )
        , .AWSIZE   ( BFM_AWSIZE   )
        , .AWBURST  ( BFM_AWBURST  )
        `ifdef AMBA_AXI_CACHE
        , .AWCACHE  ( BFM_AWCACHE  )
        `endif
        `ifdef AMBA_AXI_PROT
        , .AWPROT   ( BFM_AWPROT   )
        `endif
        , .AWVALID  ( BFM_AWVALID  )
        , .AWREADY  ( BFM_AWREADY  )
        `ifdef AMBA_AXI4
        , .AWQOS    ( BFM_AWQOS    )
        , .AWREGION ( BFM_AWREGION )
        `endif
        , .WID      ( BFM_WID      ) //[AXI_WIDTH_ID-1:0]
        , .WDATA    ( BFM_WDATA    )
        , .WSTRB    ( BFM_WSTRB    )
        , .WLAST    ( BFM_WLAST    )
        , .WVALID   ( BFM_WVALID   )
        , .WREADY   ( BFM_WREADY   )
        , .BID      ( BFM_BID[AXI_WIDTH_ID-1:0])
        , .BRESP    ( BFM_BRESP    )
        , .BVALID   ( BFM_BVALID   )
        , .BREADY   ( BFM_BREADY   )
        , .ARID     ( BFM_ARID     ) //[AXI_WIDTH_ID-1:0]
        , .ARADDR   ( BFM_ARADDR   )
        , .ARLEN    ( BFM_ARLEN    )
        , .ARLOCK   ( BFM_ARLOCK   )
        , .ARSIZE   ( BFM_ARSIZE   )
        , .ARBURST  ( BFM_ARBURST  )
        `ifdef AMBA_AXI_CACHE
        , .ARCACHE  ( BFM_ARCACHE  )
        `endif
        `ifdef AMBA_AXI_PROT
        , .ARPROT   ( BFM_ARPROT   )
        `endif
        , .ARVALID  ( BFM_ARVALID  )
        , .ARREADY  ( BFM_ARREADY  )
        `ifdef AMBA_AXI4
        , .ARQOS    ( BFM_ARQOS    )
        , .ARREGION ( BFM_ARREGION )
        `endif
        , .RID      ( BFM_RID[AXI_WIDTH_ID-1:0]) //[AXI_WIDTH_ID-1:0]
        , .RDATA    ( BFM_RDATA    )
        , .RRESP    ( BFM_RRESP    )
        , .RLAST    ( BFM_RLAST    )
        , .RVALID   ( BFM_RVALID   )
        , .RREADY   ( BFM_RREADY   )
        , .IRQ      ( GPOUT[0]     )
        , .FIQ      ( GPOUT[1]     )
        , .GPOUT    ( GPOUT        )
        , .GPIN     ( GPOUT        )
   );
   //---------------------------------------------------------------------------
   axi_to_apb_s4 #(.AXI_WIDTH_CID(AXI_WIDTH_CID)// Channel ID width in bits
                  ,.AXI_WIDTH_ID (AXI_WIDTH_ID )// ID width in bits
                  ,.AXI_WIDTH_AD (AXI_WIDTH_AD )// address width
                  ,.AXI_WIDTH_DA (AXI_WIDTH_DA )// data width
                  ,.WIDTH_PAD    (WIDTH_PAD)// address width
                  ,.WIDTH_PDA    (WIDTH_PDA)// data width
                  ,.ADDR_PBASE0  (ADDR_PBASE0),.ADDR_PLENGTH0(ADDR_PLENGTH0)
                  ,.ADDR_PBASE1  (ADDR_PBASE1),.ADDR_PLENGTH1(ADDR_PLENGTH1)
                  ,.ADDR_PBASE2  (ADDR_PBASE2),.ADDR_PLENGTH2(ADDR_PLENGTH2)
                  ,.ADDR_PBASE3  (ADDR_PBASE3),.ADDR_PLENGTH3(ADDR_PLENGTH3)
                  ,.CLOCK_RATIO  (2'b00)// 0=1:1, 3=async
                  )
   u_axi_to_apb (
          .ARESETn            ( BFM_ARESETn    )
        , .ACLK               ( BFM_ACLK       )
        , .AWID               ({BFM_MID,BFM_AWID})
        , .AWADDR             ( BFM_AWADDR     )
        , .AWLEN              ( BFM_AWLEN      )
        , .AWLOCK             ( BFM_AWLOCK     )
        , .AWSIZE             ( BFM_AWSIZE     )
        , .AWBURST            ( BFM_AWBURST    )
        `ifdef AMBA_AXI_CACHE
        , .AWCACHE            ( BFM_AWCACHE    )
        `endif
        `ifdef AMBA_AXI_PROT  
        , .AWPROT             ( BFM_AWPROT     )
        `endif
        , .AWVALID            ( BFM_AWVALID    )
        , .AWREADY            ( BFM_AWREADY    )
        `ifdef AMBA_AXI4      
        , .AWQOS              ( BFM_AWQOS      )
        , .AWREGION           ( BFM_AWREGION   )
        `endif
        , .WID                ({BFM_MID,BFM_WID})
        , .WDATA              ( BFM_WDATA      )
        , .WSTRB              ( BFM_WSTRB      )
        , .WLAST              ( BFM_WLAST      )
        , .WVALID             ( BFM_WVALID     )
        , .WREADY             ( BFM_WREADY     )
        , .BID                ( BFM_BID        ) //[AXI_WIDTH_SID-1:0]
        , .BRESP              ( BFM_BRESP      )
        , .BVALID             ( BFM_BVALID     )
        , .BREADY             ( BFM_BREADY     )
        , .ARID               ({BFM_MID,BFM_ARID})
        , .ARADDR             ( BFM_ARADDR     )
        , .ARLEN              ( BFM_ARLEN      )
        , .ARLOCK             ( BFM_ARLOCK     )
        , .ARSIZE             ( BFM_ARSIZE     )
        , .ARBURST            ( BFM_ARBURST    )
        `ifdef AMBA_AXI_CACHE
        , .ARCACHE            ( BFM_ARCACHE    )
        `endif
        `ifdef AMBA_AXI_PROT
        , .ARPROT             ( BFM_ARPROT     )
        `endif
        , .ARVALID            ( BFM_ARVALID    )
        , .ARREADY            ( BFM_ARREADY    )
        `ifdef AMBA_AXI4     
        , .ARQOS              ( BFM_ARQOS      )
        , .ARREGION           ( BFM_ARREGION   )
        `endif
        , .RID                ( BFM_RID        ) //[AXI_WIDTH_SID-1:0]
        , .RDATA              ( BFM_RDATA      )
        , .RRESP              ( BFM_RRESP      )
        , .RLAST              ( BFM_RLAST      )
        , .RVALID             ( BFM_RVALID     )
        , .RREADY             ( BFM_RREADY     )
        , .PRESETn            ( PRESETn        )
        , .PCLK               ( PCLK           )
        , .S_PADDR            ( S_PADDR        )
        , .S_PENABLE          ( S_PENABLE      )
        , .S_PWRITE           ( S_PWRITE       )
        , .S_PWDATA           ( S_PWDATA       )
        , .S0_PSEL            ( S0_PSEL      )
        , .S0_PRDATA          ( S0_PRDATA    )
        `ifdef AMBA_APB3
        , .S0_PREADY          ( S0_PREADY    )
        , .S0_PSLVERR         ( S0_PSLVERR   )
        `endif
        , .S1_PSEL            ( S1_PSEL      )
        , .S1_PRDATA          ( S1_PRDATA    )
        `ifdef AMBA_APB3
        , .S1_PREADY          ( S1_PREADY    )
        , .S1_PSLVERR         ( S1_PSLVERR   )
        `endif
        , .S2_PSEL            ( S2_PSEL      )
        , .S2_PRDATA          ( S2_PRDATA    )
        `ifdef AMBA_APB3
        , .S2_PREADY          ( S2_PREADY    )
        , .S2_PSLVERR         ( S2_PSLVERR   )
        `endif
        , .S3_PSEL            ( S3_PSEL      )
        , .S3_PRDATA          ( S3_PRDATA    )
        `ifdef AMBA_APB3
        , .S3_PREADY          ( S3_PREADY    )
        , .S3_PSLVERR         ( S3_PSLVERR   )
        `endif
        `ifdef AMBA_APB4
        , .S_PSTRB            ( S_PSTRB        )
        , .S_PPROT            ( S_PPROT        )
        `endif
   );
   //---------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
// Revision History
//
// 2020.07.10: Started by Ando Ki (adki@future-ds.com)
//------------------------------------------------------------------------------
