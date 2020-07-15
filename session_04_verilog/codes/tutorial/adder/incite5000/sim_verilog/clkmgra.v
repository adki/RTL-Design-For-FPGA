`timescale 1ns / 1ps

module clkmgra (
    SYS_CLKi,
    SYS_CLK,
    SYS_CLKDV,
    SYS_CLKFX,
    SYS_CLK_LOCKED,
    SYS_CLK90,
    SYS_CLK180,
    SYS_CLK270,
    SYS_CLK2X,
    SYS_CLK2X180,
    SYS_CLK_RST );
    input		SYS_CLKi;
    output		SYS_CLK;
    output		SYS_CLKDV;
    output		SYS_CLKFX;
    output		SYS_CLK_LOCKED;
    output		SYS_CLK90;
    output		SYS_CLK180;
    output		SYS_CLK270;
    output		SYS_CLK2X;
    output		SYS_CLK2X180;
    input		SYS_CLK_RST;

    wire 		intb_SYS_CLKi;
    wire 		netgnd;
    wire 		netvcc;
    wire 		SYS_CLK;
    wire 		SYS_CLK2X;
    wire 		SYS_CLK2X180;
    wire 		SYS_CLK90;
    wire 		SYS_CLK180;
    wire 		SYS_CLK270;
    wire 		SYS_CLK_LOCKED;
    wire 		SYS_CLK_RST;
    wire 		SYS_CLKdcm_2X;
    wire 		SYS_CLKdcm_2X180;
    wire 		SYS_CLKdcm_90;
    wire 		SYS_CLKdcm_180;
    wire 		SYS_CLKdcm_270;
    wire 		SYS_CLKdcm_clk0;
    wire 		SYS_CLKdcm_dv;
    wire 		SYS_CLKdcm_fx;
    wire 		SYS_CLKDV;
    wire 		SYS_CLKFX;
    wire 		SYS_CLKi;


    GND 	ivory_GND (
        .G( netgnd )
    );



    VCC 	ivory_VCC (
        .P( netvcc )
    );



    DCM 	SYS_CLKdcm (
        .CLKFB( SYS_CLK ),
        .CLKIN( intb_SYS_CLKi ),
        .DSSEN( netgnd ),
        .PSCLK( netgnd ),
        .PSEN( netgnd ),
        .PSINCDEC( netgnd ),
        .RST( SYS_CLK_RST ),
        .CLK0( SYS_CLKdcm_clk0 ),
        .CLK90( SYS_CLKdcm_90 ),
        .CLK180( SYS_CLKdcm_180 ),
        .CLK270( SYS_CLKdcm_270 ),
        .CLK2X( SYS_CLKdcm_2X ),
        .CLK2X180( SYS_CLKdcm_2X180 ),
        .CLKDV( SYS_CLKdcm_dv ),
        .CLKFX( SYS_CLKdcm_fx ),
        .CLKFX180(  ),
        .LOCKED( SYS_CLK_LOCKED )
    );



    BUFG 	BUFG_SYS_CLK (
        .I( SYS_CLKdcm_clk0 ),
        .O( SYS_CLK )
    );



    IBUFG 	ICPAD_SYS_CLKi (
        .I( SYS_CLKi ),
        .O( intb_SYS_CLKi )
    );



    BUFG 	BUFG_SYS_CLKDV (
        .I( SYS_CLKdcm_dv ),
        .O( SYS_CLKDV )
    );



    BUFG 	BUFG_SYS_CLKFX (
        .I( SYS_CLKdcm_fx ),
        .O( SYS_CLKFX )
    );



    BUFG 	BUFG_SYS_CLK90 (
        .I( SYS_CLKdcm_90 ),
        .O( SYS_CLK90 )
    );



    BUFG 	BUFG_SYS_CLK180 (
        .I( SYS_CLKdcm_180 ),
        .O( SYS_CLK180 )
    );



    BUFG 	BUFG_SYS_CLK270 (
        .I( SYS_CLKdcm_270 ),
        .O( SYS_CLK270 )
    );



    BUFG 	BUFG_SYS_CLK2X (
        .I( SYS_CLKdcm_2X ),
        .O( SYS_CLK2X )
    );



    BUFG 	BUFG_SYS_CLK2X180 (
        .I( SYS_CLKdcm_2X180 ),
        .O( SYS_CLK2X180 )
    );


    // parameter definition for SYS_CLKdcm
    defparam SYS_CLKdcm.CLKFX_MULTIPLY=2;
    defparam SYS_CLKdcm.CLKFX_DIVIDE=2;
    defparam SYS_CLKdcm.CLKDV_DIVIDE=1.5;
    defparam SYS_CLKdcm.CLKIN_PERIOD=20.8333333333;

endmodule

