//----------------------------------------------------------------
//  Copyright (c) 2011 by Ando Ki.
//  All right reserved.
//  http://www.future-ds.com
//  All rights are reserved by Ando Ki.
//  Do not use in any means or/and methods without Ando Ki's permission.
//----------------------------------------------------------------
// top.v
//----------------------------------------------------------------
// VERSION: 2011.01.01.
//----------------------------------------------------------------
`timescale 1ns/1ns

`ifndef WIDTH_AD
`define WIDTH_AD   32 // address width
`endif
`ifndef WIDTH_DA
`define WIDTH_DA   32 // data width
`endif
`ifndef ADDR_LENGTH
`define ADDR_LENGTH 12
`endif

module top ;
   //---------------------------------------------------------
   `ifdef VCD
   initial begin
       $dumpfile("wave.vcd");
       //$dumplimit(1000000);
   end
   `endif
   //---------------------------------------------------------
   localparam NUM_MASTER  = 2 
            , NUM_SLAVE   = 2;
   localparam WIDTH_CID   = 2    // Channel ID width in bits
            , WIDTH_ID    = 4    // ID width in bits
            , WIDTH_AD    =`WIDTH_AD    // address width
            , WIDTH_DA    =`WIDTH_DA    // data width
            , WIDTH_DS    =(WIDTH_DA/8)  // data strobe width
            , WIDTH_SID   =WIDTH_CID+WIDTH_ID // ID for slave
            , WIDTH_AWUSER=1  // Write-address user path
            , WIDTH_WUSER =1  // Write-data user path
            , WIDTH_BUSER =1  // Write-response user path
            , WIDTH_ARUSER=1  // read-address user path
            , WIDTH_RUSER =1; // read-data user path
   localparam ADDR_BASE0  =32'h0000_0000
            , ADDR_LENGTH0=`ADDR_LENGTH
            , ADDR_BASE1  =(ADDR_BASE0+(1<<ADDR_LENGTH0))
            , ADDR_LENGTH1=`ADDR_LENGTH;
   //---------------------------------------------------------
   reg                      ARESETn;
   reg                      ACLK   ;
   //--------------------------------------------------------------
   wire  [WIDTH_CID-1:0]     M_MID        [0:NUM_MASTER-1];
   wire  [WIDTH_ID-1:0]      M_AWID       [0:NUM_MASTER-1];
   wire  [WIDTH_AD-1:0]      M_AWADDR     [0:NUM_MASTER-1];
   `ifdef AMBA_AXI4
   wire  [ 7:0]              M_AWLEN      [0:NUM_MASTER-1];
   wire                      M_AWLOCK     [0:NUM_MASTER-1];
   `else
   wire  [ 3:0]              M_AWLEN      [0:NUM_MASTER-1];
   wire  [ 1:0]              M_AWLOCK     [0:NUM_MASTER-1];
   `endif
   wire  [ 2:0]              M_AWSIZE     [0:NUM_MASTER-1];
   wire  [ 1:0]              M_AWBURST    [0:NUM_MASTER-1];
   `ifdef AMBA_AXI_CACHE
   wire  [ 3:0]              M_AWCACHE    [0:NUM_MASTER-1];
   `endif
   `ifdef AMBA_AXI_PROT
   wire  [ 2:0]              M_AWPROT     [0:NUM_MASTER-1];
   `endif
   wire                      M_AWVALID    [0:NUM_MASTER-1];
   wire                      M_AWREADY    [0:NUM_MASTER-1];
   `ifdef AMBA_AXI4
   wire  [ 3:0]              M_AWQOS      [0:NUM_MASTER-1];
   wire  [ 3:0]              M_AWREGION   [0:NUM_MASTER-1];
   `endif
   `ifdef AMBA_AXI_AWUSER
   wire  [WIDTH_AWUSER-1:0]  M_AWUSER     [0:NUM_MASTER-1];
   `endif
   wire  [WIDTH_ID-1:0]      M_WID        [0:NUM_MASTER-1];
   wire  [WIDTH_DA-1:0]      M_WDATA      [0:NUM_MASTER-1];
   wire  [WIDTH_DS-1:0]      M_WSTRB      [0:NUM_MASTER-1];
   wire                      M_WLAST      [0:NUM_MASTER-1];
   wire                      M_WVALID     [0:NUM_MASTER-1];
   wire                      M_WREADY     [0:NUM_MASTER-1];
   `ifdef AMBA_AXI_WUSER
   wire  [WIDTH_WUSER-1:0]   M_WUSER      [0:NUM_MASTER-1];
   `endif
   wire  [WIDTH_ID-1:0]      M_BID        [0:NUM_MASTER-1];
   wire  [ 1:0]              M_BRESP      [0:NUM_MASTER-1];
   wire                      M_BVALID     [0:NUM_MASTER-1];
   wire                      M_BREADY     [0:NUM_MASTER-1];
   `ifdef AMBA_AXI_BUSER
   wire  [WIDTH_BUSER-1:0]   M_BUSER      [0:NUM_MASTER-1];
   `endif
   wire  [WIDTH_ID-1:0]      M_ARID       [0:NUM_MASTER-1];
   wire  [WIDTH_AD-1:0]      M_ARADDR     [0:NUM_MASTER-1];
   `ifdef AMBA_AXI4
   wire  [ 7:0]              M_ARLEN      [0:NUM_MASTER-1];
   wire                      M_ARLOCK     [0:NUM_MASTER-1];
   `else
   wire  [ 3:0]              M_ARLEN      [0:NUM_MASTER-1];
   wire  [ 1:0]              M_ARLOCK     [0:NUM_MASTER-1];
   `endif
   wire  [ 2:0]              M_ARSIZE     [0:NUM_MASTER-1];
   wire  [ 1:0]              M_ARBURST    [0:NUM_MASTER-1];
   `ifdef AMBA_AXI_CACHE
   wire  [ 3:0]              M_ARCACHE    [0:NUM_MASTER-1];
   `endif
   `ifdef AMBA_AXI_PROT
   wire  [ 2:0]              M_ARPROT     [0:NUM_MASTER-1];
   `endif
   wire                      M_ARVALID    [0:NUM_MASTER-1];
   wire                      M_ARREADY    [0:NUM_MASTER-1];
   `ifdef AMBA_AXI4
   wire  [ 3:0]              M_ARQOS      [0:NUM_MASTER-1];
   wire  [ 3:0]              M_ARREGION   [0:NUM_MASTER-1];
   `endif
   `ifdef AMBA_AXI_ARUSER
   wire  [WIDTH_ARUSER-1:0]  M_ARUSER     [0:NUM_MASTER-1];
   `endif
   wire  [WIDTH_ID-1:0]      M_RID        [0:NUM_MASTER-1];
   wire  [WIDTH_DA-1:0]      M_RDATA      [0:NUM_MASTER-1];
   wire  [ 1:0]              M_RRESP      [0:NUM_MASTER-1];
   wire                      M_RLAST      [0:NUM_MASTER-1];
   wire                      M_RVALID     [0:NUM_MASTER-1];
   wire                      M_RREADY     [0:NUM_MASTER-1];
   `ifdef AMBA_AXI_RUSER
   wire  [WIDTH_RUSER-1:0]   M_RUSER      [0:NUM_MASTER-1];
   `endif
   reg                       M_CSYSREQ    [0:NUM_MASTER-1];
   wire                      M_CSYSACK    [0:NUM_MASTER-1];
   wire                      M_CACTIVE    [0:NUM_MASTER-1];
   //---------------------------------------------------------
   wire  [WIDTH_SID-1:0]     S_AWID       [0:NUM_SLAVE-1];
   wire  [WIDTH_AD-1:0]      S_AWADDR     [0:NUM_SLAVE-1];
   `ifdef AMBA_AXI4
   wire  [ 7:0]              S_AWLEN      [0:NUM_SLAVE-1];
   wire                      S_AWLOCK     [0:NUM_SLAVE-1];
   `else
   wire  [ 3:0]              S_AWLEN      [0:NUM_SLAVE-1];
   wire  [ 1:0]              S_AWLOCK     [0:NUM_SLAVE-1];
   `endif
   wire  [ 2:0]              S_AWSIZE     [0:NUM_SLAVE-1];
   wire  [ 1:0]              S_AWBURST    [0:NUM_SLAVE-1];
   `ifdef AMBA_AXI_CACHE
   wire  [ 3:0]              S_AWCACHE    [0:NUM_SLAVE-1];
   `endif
   `ifdef AMBA_AXI_PROT
   wire  [ 2:0]              S_AWPROT     [0:NUM_SLAVE-1];
   `endif
   wire                      S_AWVALID    [0:NUM_SLAVE-1];
   wire                      S_AWREADY    [0:NUM_SLAVE-1];
   `ifdef AMBA_AXI4
   wire  [ 3:0]              S_AWQOS      [0:NUM_SLAVE-1];
   wire  [ 3:0]              S_AWREGION   [0:NUM_SLAVE-1];
   `endif
   `ifdef AMBA_AXI_AWUSER
   wire  [WIDTH_AWUSER-1:0]  S_AWUSER     [0:NUM_SLAVE-1];
   `endif
   wire  [WIDTH_SID-1:0]     S_WID        [0:NUM_SLAVE-1];
   wire  [WIDTH_DA-1:0]      S_WDATA      [0:NUM_SLAVE-1];
   wire  [WIDTH_DS-1:0]      S_WSTRB      [0:NUM_SLAVE-1];
   wire                      S_WLAST      [0:NUM_SLAVE-1];
   wire                      S_WVALID     [0:NUM_SLAVE-1];
   wire                      S_WREADY     [0:NUM_SLAVE-1];
   `ifdef AMBA_AXI_WUSER
   wire  [WIDTH_WUSER-1:0]   S_WUSER      [0:NUM_SLAVE-1];
   `endif
   wire  [WIDTH_SID-1:0]     S_BID        [0:NUM_SLAVE-1];
   wire  [ 1:0]              S_BRESP      [0:NUM_SLAVE-1];
   wire                      S_BVALID     [0:NUM_SLAVE-1];
   wire                      S_BREADY     [0:NUM_SLAVE-1];
   `ifdef AMBA_AXI_BUSER
   wire  [WIDTH_BUSER-1:0]   S_BUSER      [0:NUM_SLAVE-1];
   `endif
   wire  [WIDTH_SID-1:0]     S_ARID       [0:NUM_SLAVE-1];
   wire  [WIDTH_AD-1:0]      S_ARADDR     [0:NUM_SLAVE-1];
   `ifdef AMBA_AXI4
   wire  [ 7:0]              S_ARLEN      [0:NUM_SLAVE-1];
   wire                      S_ARLOCK     [0:NUM_SLAVE-1];
   `else
   wire  [ 3:0]              S_ARLEN      [0:NUM_SLAVE-1];
   wire  [ 1:0]              S_ARLOCK     [0:NUM_SLAVE-1];
   `endif
   wire  [ 2:0]              S_ARSIZE     [0:NUM_SLAVE-1];
   wire  [ 1:0]              S_ARBURST    [0:NUM_SLAVE-1];
   `ifdef AMBA_AXI_CACHE
   wire  [ 3:0]              S_ARCACHE    [0:NUM_SLAVE-1];
   `endif
   `ifdef AMBA_AXI_PROT
   wire  [ 2:0]              S_ARPROT     [0:NUM_SLAVE-1];
   `endif
   wire                      S_ARVALID    [0:NUM_SLAVE-1];
   wire                      S_ARREADY    [0:NUM_SLAVE-1];
   `ifdef AMBA_AXI4
   wire  [ 3:0]              S_ARQOS      [0:NUM_SLAVE-1];
   wire  [ 3:0]              S_ARREGION   [0:NUM_SLAVE-1];
   `endif
   `ifdef AMBA_AXI_ARUSER
   wire  [WIDTH_ARUSER-1:0]  S_ARUSER     [0:NUM_SLAVE-1];
   `endif
   wire  [WIDTH_SID-1:0]     S_RID        [0:NUM_SLAVE-1];
   wire  [WIDTH_DA-1:0]      S_RDATA      [0:NUM_SLAVE-1];
   wire  [ 1:0]              S_RRESP      [0:NUM_SLAVE-1];
   wire                      S_RLAST      [0:NUM_SLAVE-1];
   wire                      S_RVALID     [0:NUM_SLAVE-1];
   wire                      S_RREADY     [0:NUM_SLAVE-1];
   `ifdef AMBA_AXI_RUSER
   wire  [WIDTH_RUSER-1:0]   S_RUSER      [0:NUM_SLAVE-1];
   `endif
   reg                       S_CSYSREQ    [0:NUM_SLAVE-1];
   wire                      S_CSYSACK    [0:NUM_SLAVE-1];
   wire                      S_CACTIVE    [0:NUM_SLAVE-1];
   //---------------------------------------------------------
   axi_switch_m2s2
       #(.WIDTH_CID   (WIDTH_CID   )
        ,.WIDTH_ID    (WIDTH_ID    )
        ,.WIDTH_AD    (WIDTH_AD    )
        ,.WIDTH_DA    (WIDTH_DA    )
        ,.WIDTH_DS    (WIDTH_DS    )
        ,.WIDTH_SID   (WIDTH_SID   )
        ,.WIDTH_AWUSER(WIDTH_AWUSER)
        ,.WIDTH_WUSER (WIDTH_WUSER )
        ,.WIDTH_BUSER (WIDTH_BUSER )
        ,.WIDTH_ARUSER(WIDTH_ARUSER)
        ,.WIDTH_RUSER (WIDTH_RUSER )
        ,.ADDR_BASE0  (ADDR_BASE0  )
        ,.ADDR_LENGTH0(ADDR_LENGTH0)
        ,.ADDR_BASE1  (ADDR_BASE1  )
        ,.ADDR_LENGTH1(ADDR_LENGTH1)
        )
   Uaxi_switch_m2s2 (
          .ARESETn              (ARESETn      )
        , .ACLK                 (ACLK         )
        , .M0_MID               (M_MID     [0])
        , .M0_AWID              (M_AWID    [0])
        , .M0_AWADDR            (M_AWADDR  [0])
        , .M0_AWLEN             (M_AWLEN   [0])
        , .M0_AWLOCK            (M_AWLOCK  [0])
        , .M0_AWSIZE            (M_AWSIZE  [0])
        , .M0_AWBURST           (M_AWBURST [0])
   `ifdef AMBA_AXI_CACHE
        , .M0_AWCACHE           (M_AWCACHE [0])
   `endif
   `ifdef AMBA_AXI_PROT
        , .M0_AWPROT            (M_AWPROT  [0])
   `endif
        , .M0_AWVALID           (M_AWVALID [0])
        , .M0_AWREADY           (M_AWREADY [0])
        `ifdef AMBA_AXI4
        , .M0_AWQOS             (M_AWQOS   [0])
        , .M0_AWREGION          (M_AWREGION[0])
        `endif
        `ifdef AMBA_AXI_AWUSER
        , .M0_AWUSER            (M_AWUSER  [0])
        `endif
        , .M0_WID               (M_WID     [0])
        , .M0_WDATA             (M_WDATA   [0])
        , .M0_WSTRB             (M_WSTRB   [0])
        , .M0_WLAST             (M_WLAST   [0])
        , .M0_WVALID            (M_WVALID  [0])
        , .M0_WREADY            (M_WREADY  [0])
        `ifdef AMBA_AXI_WUSER
        , .M0_WUSER             (M_WUSER   [0])
        `endif
        , .M0_BID               (M_BID     [0])
        , .M0_BRESP             (M_BRESP   [0])
        , .M0_BVALID            (M_BVALID  [0])
        , .M0_BREADY            (M_BREADY  [0])
        `ifdef AMBA_AXI_BUSER
        , .M0_BUSER             (M_BUSER   [0])
        `endif
        , .M0_ARID              (M_ARID    [0])
        , .M0_ARADDR            (M_ARADDR  [0])
        , .M0_ARLEN             (M_ARLEN   [0])
        , .M0_ARLOCK            (M_ARLOCK  [0])
        , .M0_ARSIZE            (M_ARSIZE  [0])
        , .M0_ARBURST           (M_ARBURST [0])
   `ifdef AMBA_AXI_CACHE
        , .M0_ARCACHE           (M_ARCACHE [0])
   `endif
   `ifdef AMBA_AXI_PROT
        , .M0_ARPROT            (M_ARPROT  [0])
   `endif
        , .M0_ARVALID           (M_ARVALID [0])
        , .M0_ARREADY           (M_ARREADY [0])
        `ifdef AMBA_AXI4
        , .M0_ARQOS             (M_ARQOS   [0])
        , .M0_ARREGION          (M_ARREGION[0])
        `endif
        `ifdef AMBA_AXI_ARUSER
        , .M0_ARUSER            (M_ARUSER  [0])
        `endif
        , .M0_RID               (M_RID     [0])
        , .M0_RDATA             (M_RDATA   [0])
        , .M0_RRESP             (M_RRESP   [0])
        , .M0_RLAST             (M_RLAST   [0])
        , .M0_RVALID            (M_RVALID  [0])
        , .M0_RREADY            (M_RREADY  [0])
        `ifdef AMBA_AXI_RUSER
        , .M0_RUSER             (M_RUSER   [0])
        `endif
        , .M1_MID               (M_MID     [1])
        , .M1_AWID              (M_AWID    [1])
        , .M1_AWADDR            (M_AWADDR  [1])
        , .M1_AWLEN             (M_AWLEN   [1])
        , .M1_AWLOCK            (M_AWLOCK  [1])
        , .M1_AWSIZE            (M_AWSIZE  [1])
        , .M1_AWBURST           (M_AWBURST [1])
   `ifdef AMBA_AXI_CACHE
        , .M1_AWCACHE           (M_AWCACHE [1])
   `endif
   `ifdef AMBA_AXI_PROT
        , .M1_AWPROT            (M_AWPROT  [1])
   `endif
        , .M1_AWVALID           (M_AWVALID [1])
        , .M1_AWREADY           (M_AWREADY [1])
        `ifdef AMBA_AXI4
        , .M1_AWQOS             (M_AWQOS   [1])
        , .M1_AWREGION          (M_AWREGION[1])
        `endif
        `ifdef AMBA_AXI_AWUSER
        , .M1_AWUSER            (M_AWUSER  [1])
        `endif
        , .M1_WID               (M_WID     [1])
        , .M1_WDATA             (M_WDATA   [1])
        , .M1_WSTRB             (M_WSTRB   [1])
        , .M1_WLAST             (M_WLAST   [1])
        , .M1_WVALID            (M_WVALID  [1])
        , .M1_WREADY            (M_WREADY  [1])
        `ifdef AMBA_AXI_WUSER
        , .M1_WUSER             (M_WUSER   [1])
        `endif
        , .M1_BID               (M_BID     [1])
        , .M1_BRESP             (M_BRESP   [1])
        , .M1_BVALID            (M_BVALID  [1])
        , .M1_BREADY            (M_BREADY  [1])
        `ifdef AMBA_AXI_BUSER
        , .M1_BUSER             (M_BUSER   [1])
        `endif
        , .M1_ARID              (M_ARID    [1])
        , .M1_ARADDR            (M_ARADDR  [1])
        , .M1_ARLEN             (M_ARLEN   [1])
        , .M1_ARLOCK            (M_ARLOCK  [1])
        , .M1_ARSIZE            (M_ARSIZE  [1])
        , .M1_ARBURST           (M_ARBURST [1])
   `ifdef AMBA_AXI_CACHE
        , .M1_ARCACHE           (M_ARCACHE [1])
   `endif
   `ifdef AMBA_AXI_PROT
        , .M1_ARPROT            (M_ARPROT  [1])
   `endif
        , .M1_ARVALID           (M_ARVALID [1])
        , .M1_ARREADY           (M_ARREADY [1])
        `ifdef AMBA_AXI4
        , .M1_ARQOS             (M_ARQOS   [1])
        , .M1_ARREGION          (M_ARREGION[1])
        `endif
        `ifdef AMBA_AXI_ARUSER
        , .M1_ARUSER            (M_ARUSER  [1])
        `endif
        , .M1_RID               (M_RID     [1])
        , .M1_RDATA             (M_RDATA   [1])
        , .M1_RRESP             (M_RRESP   [1])
        , .M1_RLAST             (M_RLAST   [1])
        , .M1_RVALID            (M_RVALID  [1])
        , .M1_RREADY            (M_RREADY  [1])
        `ifdef AMBA_AXI_RUSER
        , .M1_RUSER             (M_RUSER   [1])
        `endif
        , .S0_AWID              (S_AWID    [0])
        , .S0_AWADDR            (S_AWADDR  [0])
        , .S0_AWLEN             (S_AWLEN   [0])
        , .S0_AWLOCK            (S_AWLOCK  [0])
        , .S0_AWSIZE            (S_AWSIZE  [0])
        , .S0_AWBURST           (S_AWBURST [0])
   `ifdef AMBA_AXI_CACHE
        , .S0_AWCACHE           (S_AWCACHE [0])
   `endif
   `ifdef AMBA_AXI_PROT
        , .S0_AWPROT            (S_AWPROT  [0])
   `endif
        , .S0_AWVALID           (S_AWVALID [0])
        , .S0_AWREADY           (S_AWREADY [0])
        `ifdef AMBA_AXI4
        , .S0_AWQOS             (S_AWQOS   [0])
        , .S0_AWREGION          (S_AWREGION[0])
        `endif
        `ifdef AMBA_AXI_AWUSER
        , .S0_AWUSER            (S_AWUSER  [0])
        `endif
        , .S0_WID               (S_WID     [0])
        , .S0_WDATA             (S_WDATA   [0])
        , .S0_WSTRB             (S_WSTRB   [0])
        , .S0_WLAST             (S_WLAST   [0])
        , .S0_WVALID            (S_WVALID  [0])
        , .S0_WREADY            (S_WREADY  [0])
        `ifdef AMBA_AXI_WUSER
        , .S0_WUSER             (S_WUSER   [0])
        `endif
        , .S0_BID               (S_BID     [0])
        , .S0_BRESP             (S_BRESP   [0])
        , .S0_BVALID            (S_BVALID  [0])
        , .S0_BREADY            (S_BREADY  [0])
        `ifdef AMBA_AXI_BUSER
        , .S0_BUSER             (S_BUSER   [0])
        `endif
        , .S0_ARID              (S_ARID    [0])
        , .S0_ARADDR            (S_ARADDR  [0])
        , .S0_ARLEN             (S_ARLEN   [0])
        , .S0_ARLOCK            (S_ARLOCK  [0])
        , .S0_ARSIZE            (S_ARSIZE  [0])
        , .S0_ARBURST           (S_ARBURST [0])
   `ifdef AMBA_AXI_CACHE
        , .S0_ARCACHE           (S_ARCACHE [0])
   `endif
   `ifdef AMBA_AXI_PROT
        , .S0_ARPROT            (S_ARPROT  [0])
   `endif
        , .S0_ARVALID           (S_ARVALID [0])
        , .S0_ARREADY           (S_ARREADY [0])
        `ifdef AMBA_AXI4
        , .S0_ARQOS             (S_ARQOS   [0])
        , .S0_ARREGION          (S_ARREGION[0])
        `endif
        `ifdef AMBA_AXI_ARUSER
        , .S0_ARUSER            (S_ARUSER  [0])
        `endif
        , .S0_RID               (S_RID     [0])
        , .S0_RDATA             (S_RDATA   [0])
        , .S0_RRESP             (S_RRESP   [0])
        , .S0_RLAST             (S_RLAST   [0])
        , .S0_RVALID            (S_RVALID  [0])
        , .S0_RREADY            (S_RREADY  [0])
        `ifdef AMBA_AXI_RUSER
        , .S0_RUSER             (S_RUSER   [0])
        `endif
        , .S1_AWID              (S_AWID    [1])
        , .S1_AWADDR            (S_AWADDR  [1])
        , .S1_AWLEN             (S_AWLEN   [1])
        , .S1_AWLOCK            (S_AWLOCK  [1])
        , .S1_AWSIZE            (S_AWSIZE  [1])
        , .S1_AWBURST           (S_AWBURST [1])
   `ifdef AMBA_AXI_CACHE
        , .S1_AWCACHE           (S_AWCACHE [1])
   `endif
   `ifdef AMBA_AXI_PROT
        , .S1_AWPROT            (S_AWPROT  [1])
   `endif
        , .S1_AWVALID           (S_AWVALID [1])
        , .S1_AWREADY           (S_AWREADY [1])
        `ifdef AMBA_AXI4                      
        , .S1_AWQOS             (S_AWQOS   [1])
        , .S1_AWREGION          (S_AWREGION[1])
        `endif                                
        `ifdef AMBA_AXI_AWUSER                
        , .S1_AWUSER            (S_AWUSER  [1])
        `endif                                
        , .S1_WID               (S_WID     [1])
        , .S1_WDATA             (S_WDATA   [1])
        , .S1_WSTRB             (S_WSTRB   [1])
        , .S1_WLAST             (S_WLAST   [1])
        , .S1_WVALID            (S_WVALID  [1])
        , .S1_WREADY            (S_WREADY  [1])
        `ifdef AMBA_AXI_WUSER                 
        , .S1_WUSER             (S_WUSER   [1])
        `endif                                
        , .S1_BID               (S_BID     [1])
        , .S1_BRESP             (S_BRESP   [1])
        , .S1_BVALID            (S_BVALID  [1])
        , .S1_BREADY            (S_BREADY  [1])
        `ifdef AMBA_AXI_BUSER                 
        , .S1_BUSER             (S_BUSER   [1])
        `endif                                
        , .S1_ARID              (S_ARID    [1])
        , .S1_ARADDR            (S_ARADDR  [1])
        , .S1_ARLEN             (S_ARLEN   [1])
        , .S1_ARLOCK            (S_ARLOCK  [1])
        , .S1_ARSIZE            (S_ARSIZE  [1])
        , .S1_ARBURST           (S_ARBURST [1])
   `ifdef AMBA_AXI_CACHE
        , .S1_ARCACHE           (S_ARCACHE [1])
   `endif
   `ifdef AMBA_AXI_PROT
        , .S1_ARPROT            (S_ARPROT  [1])
   `endif
        , .S1_ARVALID           (S_ARVALID [1])
        , .S1_ARREADY           (S_ARREADY [1])
        `ifdef AMBA_AXI4                      
        , .S1_ARQOS             (S_ARQOS   [1])
        , .S1_ARREGION          (S_ARREGION[1])
        `endif                                
        `ifdef AMBA_AXI_ARUSER                
        , .S1_ARUSER            (S_ARUSER  [1])
        `endif                                
        , .S1_RID               (S_RID     [1])
        , .S1_RDATA             (S_RDATA   [1])
        , .S1_RRESP             (S_RRESP   [1])
        , .S1_RLAST             (S_RLAST   [1])
        , .S1_RVALID            (S_RVALID  [1])
        , .S1_RREADY            (S_RREADY  [1])
        `ifdef AMBA_AXI_RUSER                 
        , .S1_RUSER             (S_RUSER   [1])
        `endif
   );
   //---------------------------------------------------------
   generate
   genvar idm;
   for (idm=0; idm<NUM_MASTER; idm=idm+1) begin: MST_BLK
        bfm_axi #(.MST_ID   (idm+1    ) // Master ID
                 ,.WIDTH_CID(WIDTH_CID)
                 ,.WIDTH_ID (WIDTH_ID ) // ID width in bits
                 ,.WIDTH_AD (WIDTH_AD ) // address width
                 ,.WIDTH_DA (WIDTH_DA ))// data width
        u_bfm_axi (
              .ARESETn   (ARESETn      )
            , .ACLK      (ACLK         )
            , .MID       (M_MID     [idm])
            , .AWID      (M_AWID    [idm])
            , .AWADDR    (M_AWADDR  [idm])
            , .AWLEN     (M_AWLEN   [idm])
            , .AWLOCK    (M_AWLOCK  [idm])
            , .AWSIZE    (M_AWSIZE  [idm])
            , .AWBURST   (M_AWBURST [idm])
   `ifdef AMBA_AXI_CACHE
            , .AWCACHE   (M_AWCACHE [idm])
   `endif
   `ifdef AMBA_AXI_PROT
            , .AWPROT    (M_AWPROT  [idm])
   `endif
            , .AWVALID   (M_AWVALID [idm])
            , .AWREADY   (M_AWREADY [idm])
        `ifdef AMBA_AXI4
            , .AWQOS     (M_AWQOS   [idm])
            , .AWREGION  (M_AWREGION[idm])
        `endif
            , .WID       (M_WID     [idm])
            , .WDATA     (M_WDATA   [idm])
            , .WSTRB     (M_WSTRB   [idm])
            , .WLAST     (M_WLAST   [idm])
            , .WVALID    (M_WVALID  [idm])
            , .WREADY    (M_WREADY  [idm])
            , .BID       (M_BID     [idm])
            , .BRESP     (M_BRESP   [idm])
            , .BVALID    (M_BVALID  [idm])
            , .BREADY    (M_BREADY  [idm])
            , .ARID      (M_ARID    [idm])
            , .ARADDR    (M_ARADDR  [idm])
            , .ARLEN     (M_ARLEN   [idm])
            , .ARLOCK    (M_ARLOCK  [idm])
            , .ARSIZE    (M_ARSIZE  [idm])
            , .ARBURST   (M_ARBURST [idm])
   `ifdef AMBA_AXI_CACHE
            , .ARCACHE   (M_ARCACHE [idm])
   `endif
   `ifdef AMBA_AXI_PROT
            , .ARPROT    (M_ARPROT  [idm])
   `endif
            , .ARVALID   (M_ARVALID [idm])
            , .ARREADY   (M_ARREADY [idm])
        `ifdef AMBA_AXI4
            , .ARQOS     (M_ARQOS   [idm])
            , .ARREGION  (M_ARREGION[idm])
        `endif
            , .RID       (M_RID     [idm])
            , .RDATA     (M_RDATA   [idm])
            , .RRESP     (M_RRESP   [idm])
            , .RLAST     (M_RLAST   [idm])
            , .RVALID    (M_RVALID  [idm])
            , .RREADY    (M_RREADY  [idm])
            , .CSYSREQ   (M_CSYSREQ [idm])
            , .CSYSACK   (M_CSYSACK [idm])
            , .CACTIVE   (M_CACTIVE [idm])
        );
   end
   endgenerate
   //---------------------------------------------------------
   generate
   genvar ids;
   for (ids=0; ids<NUM_SLAVE; ids=ids+1) begin: SLV_BLK
        mem_axi #(.AXI_WIDTH_CID  (WIDTH_CID)// Channel ID width in bits
                 ,.AXI_WIDTH_ID   (WIDTH_ID )// ID width in bits
                 ,.AXI_WIDTH_AD   (WIDTH_AD )// address width
                 ,.AXI_WIDTH_DA   (WIDTH_DA )// data width
                 ,.AXI_WIDTH_DS   (WIDTH_DS )// data strobe width
                 ,.ADDR_LENGTH(ADDR_LENGTH0) // effective addre bits
                 )
        u_mem_axi (
               .ARESETn  (ARESETn         )
             , .ACLK     (ACLK            )
             , .AWID     (S_AWID     [ids])
             , .AWADDR   (S_AWADDR   [ids])
             , .AWLEN    (S_AWLEN    [ids])
             , .AWLOCK   (S_AWLOCK   [ids])
             , .AWSIZE   (S_AWSIZE   [ids])
             , .AWBURST  (S_AWBURST  [ids])
   `ifdef AMBA_AXI_CACHE
             , .AWCACHE  (S_AWCACHE  [ids])
   `endif
   `ifdef AMBA_AXI_PROT
             , .AWPROT   (S_AWPROT   [ids])
   `endif
             , .AWVALID  (S_AWVALID  [ids])
             , .AWREADY  (S_AWREADY  [ids])
        `ifdef AMBA_AXI4
             , .AWQOS    (S_AWQOS    [ids])
             , .AWREGION (S_AWREGION [ids])
        `endif
             , .WID      (S_WID      [ids])
             , .WDATA    (S_WDATA    [ids])
             , .WSTRB    (S_WSTRB    [ids])
             , .WLAST    (S_WLAST    [ids])
             , .WVALID   (S_WVALID   [ids])
             , .WREADY   (S_WREADY   [ids])
             , .BID      (S_BID      [ids])
             , .BRESP    (S_BRESP    [ids])
             , .BVALID   (S_BVALID   [ids])
             , .BREADY   (S_BREADY   [ids])
             , .ARID     (S_ARID     [ids])
             , .ARADDR   (S_ARADDR   [ids])
             , .ARLEN    (S_ARLEN    [ids])
             , .ARLOCK   (S_ARLOCK   [ids])
             , .ARSIZE   (S_ARSIZE   [ids])
             , .ARBURST  (S_ARBURST  [ids])
   `ifdef AMBA_AXI_CACHE
             , .ARCACHE  (S_ARCACHE  [ids])
   `endif
   `ifdef AMBA_AXI_PROT
             , .ARPROT   (S_ARPROT   [ids])
   `endif
             , .ARVALID  (S_ARVALID  [ids])
             , .ARREADY  (S_ARREADY  [ids])
        `ifdef AMBA_AXI4
             , .ARQOS    (S_ARQOS    [ids])
             , .ARREGION (S_ARREGION [ids])
        `endif
             , .RID      (S_RID      [ids])
             , .RDATA    (S_RDATA    [ids])
             , .RRESP    (S_RRESP    [ids])
             , .RLAST    (S_RLAST    [ids])
             , .RVALID   (S_RVALID   [ids])
             , .RREADY   (S_RREADY   [ids])
             , .CSYSREQ  (S_CSYSREQ  [ids])
             , .CSYSACK  (S_CSYSACK  [ids])
             , .CACTIVE  (S_CACTIVE  [ids])
        );
   end
   endgenerate
   //---------------------------------------------------------
   wire [NUM_MASTER-1:0] DONE;
   generate
   genvar xds;
   for (xds=0; xds<NUM_MASTER; xds=xds+1) begin :BLK_XDS
        assign DONE[xds] = MST_BLK[xds].u_bfm_axi.DONE;
   end
   endgenerate
   //---------------------------------------------------------
   integer nx;
   always #5 ACLK = ~ACLK;
   initial begin
       ACLK    = 0;
       ARESETn = 0;
       for (nx=0; nx<NUM_MASTER; nx=nx+1) M_CSYSREQ[nx] = 1;
       for (nx=0; nx<NUM_SLAVE;  nx=nx+1) S_CSYSREQ[nx] = 1;
       repeat (2) @ (posedge ACLK);
       ARESETn = 1;
       repeat (2) @ (posedge ACLK);
       for (nx=0; nx<NUM_MASTER; nx=nx+1) wait(M_CACTIVE[nx]==1'b1);
       repeat (5) @ (posedge ACLK);
       for (nx=0; nx<NUM_MASTER; nx=nx+1) wait(&DONE);
       $finish(2);
   end
   //---------------------------------------------------------
   `ifdef VCD
   initial begin
       $dumpvars(0);
   end
   `endif
   //---------------------------------------------------------
endmodule
//----------------------------------------------------------------
// Revision History
//
// 2011.01.01: Started by Ando Ki (adki@future-ds.com)
//----------------------------------------------------------------
