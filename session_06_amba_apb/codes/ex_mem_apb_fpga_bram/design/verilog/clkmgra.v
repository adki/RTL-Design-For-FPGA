`ifndef CLKMGRA_V
`define CLKMGRA_V
//------------------------------------------------------------------------------
// Copyright (c) 2018 by Future Design Systems Co., Ltd.
// All right reserved.
//------------------------------------------------------------------------------
`timescale 1ns/1ps

module clkmgra     
     #(parameter INPUT_CLOCK_FREQ =  50_000_000
               , SYSCLK_FREQ      =  80_000_000
               , CLKOUT1_FREQ     =  80_000_000 // USR CLK
               , CLKOUT2_FREQ     =  25_000_000
               , CLKOUT3_FREQ     =  50_000_000
               , CLKOUT4_FREQ     = 250_000_000 // Chipscope or Ila
               , FPGA_FAMILY      = "VIRTEX6"  )  // ARTIX7, VIRTEX6, SPARTAN6, 
(
      input   wire    OSC_IN
    , output  wire    OSC_OUT
    , output  wire    SYS_CLK_OUT
    , output  wire    CLKOUT1
    , output  wire    CLKOUT2
    , output  wire    CLKOUT3
    , output  wire    CLKOUT4
    , output  wire    SYS_CLK_LOCKED
);
generate
//------------------------------------------------------------------------------
if (FPGA_FAMILY=="VIRTEX6")
begin: VIRTEX6_CLKMGRA 
    wire SYS_CLK_CLKFB   ;
    wire SYS_CLK_CLKOUT0 ;
    wire SYS_CLK_CLKOUT1 ;
    wire SYS_CLK_CLKOUT2 ;
    wire SYS_CLK_CLKOUT3 ;
    wire SYS_CLK_CLKOUT4 ;

    BUFG BUFG_OSC_OUT  ( .I( OSC_IN          ), .O( OSC_OUT     ));
    BUFG BUFG_SYS_CLK  ( .I( SYS_CLK_CLKOUT0 ), .O( SYS_CLK_OUT ));
    BUFG BUFG_CLKOUT1  ( .I( SYS_CLK_CLKOUT1 ), .O( CLKOUT1     ));
    BUFG BUFG_CLKOUT2  ( .I( SYS_CLK_CLKOUT2 ), .O( CLKOUT2     ));
    BUFG BUFG_CLKOUT3  ( .I( SYS_CLK_CLKOUT3 ), .O( CLKOUT3     ));
    BUFG BUFG_CLKOUT4  ( .I( SYS_CLK_CLKOUT4 ), .O( CLKOUT4     ));

    localparam real CLK_IN_MHZ = INPUT_CLOCK_FREQ/1_000_000.0;
    localparam real CLK_IN_PERIOD_NS = 1000.0/CLK_IN_MHZ;
                            // VCO= 600.000000~1600.000000 Mhz
                            // VCO= 600.000000~1200.000000 Mhz (Speed Grade 1)
    localparam real CLK_MUL =  (INPUT_CLOCK_FREQ== 66_000_000) ? 18.0
                            :  (INPUT_CLOCK_FREQ==100_000_000) ? 10.0
                            :  (INPUT_CLOCK_FREQ==125_000_000) ? 10.0
                            :  (INPUT_CLOCK_FREQ==156_250_000) ?  8.0
                            : 1_000.0/CLK_IN_MHZ; // when DIVCLK_DIVIDE is 1.
    localparam real    CLK0_DIV=(CLK_IN_MHZ*CLK_MUL)/(SYSCLK_FREQ/1_000_000.0);
    localparam integer CLK1_DIV=(CLK_IN_MHZ*CLK_MUL)/(CLKOUT1_FREQ/1_000_000)
                     , CLK2_DIV=(CLK_IN_MHZ*CLK_MUL)/(CLKOUT2_FREQ/1_000_000)
                     , CLK3_DIV=(CLK_IN_MHZ*CLK_MUL)/(CLKOUT3_FREQ/1_000_000)
                     , CLK4_DIV=(CLK_IN_MHZ*CLK_MUL)/(CLKOUT4_FREQ/1_000_000);

    MMCM_BASE #(
          .BANDWIDTH("OPTIMIZED")
        , .CLKFBOUT_MULT_F    ( CLK_MUL          ) // 1.000~64.000
        , .CLKIN1_PERIOD      ( CLK_IN_PERIOD_NS ) // 1.000~1000.000
        , .CLKOUT0_DIVIDE_F   ( CLK0_DIV         ) // 1.000~128.000
        , .CLKOUT1_DIVIDE     ( CLK1_DIV[31:0]   ) // 1~128
        , .CLKOUT2_DIVIDE     ( CLK2_DIV[31:0]   ) // 1~128
        , .CLKOUT3_DIVIDE     ( CLK3_DIV[31:0]   ) // 1~128
        , .CLKOUT4_DIVIDE     ( CLK4_DIV[31:0]   ) // 1~128
        , .CLKOUT5_DIVIDE     ( 1                )
        , .CLKOUT6_DIVIDE     ( 1                )
        , .DIVCLK_DIVIDE      ( 1                ) // 1~128
        )
    u_SYS_CLK   (
          .CLKFBOUT  ( SYS_CLK_CLKFB   )
        , .CLKFBOUTB (                 )
        , .CLKOUT0   ( SYS_CLK_CLKOUT0 )
        , .CLKOUT0B  (                 )
        , .CLKOUT1   ( SYS_CLK_CLKOUT1 )
        , .CLKOUT1B  (                 )
        , .CLKOUT2   ( SYS_CLK_CLKOUT2 )
        , .CLKOUT2B  (                 )
        , .CLKOUT3   ( SYS_CLK_CLKOUT3 )
        , .CLKOUT3B  (                 )
        , .CLKOUT4   ( SYS_CLK_CLKOUT4 )
        , .CLKOUT5   (                 )
        , .CLKOUT6   (                 )
        , .LOCKED    ( SYS_CLK_LOCKED  )
        , .CLKFBIN   ( SYS_CLK_CLKFB   )
        , .CLKIN1    ( OSC_IN          )
        , .PWRDWN    ( 1'b0            )
        , .RST       ( 1'b0            )
    );
end
//------------------------------------------------------------------------------
else if ((FPGA_FAMILY=="VIRTEX7")||(FPGA_FAMILY=="ARTIX7 "))
begin: VIRTEX_CLKMGRA 
    wire SYS_CLK_CLKFB   ;
    wire SYS_CLK_CLKOUT0 ;
    wire SYS_CLK_CLKOUT0B;
    wire SYS_CLK_CLKOUT1 ;
    wire SYS_CLK_CLKOUT1B;
    wire SYS_CLK_CLKOUT2 ;
    wire SYS_CLK_CLKOUT3 ;
    wire SYS_CLK_CLKOUT4 ;

    BUFG BUFG_OSC_OUT  ( .I( OSC_IN          ), .O( OSC_OUT     ));
    BUFG BUFG_SYS_CLK  ( .I( SYS_CLK_CLKOUT0 ), .O( SYS_CLK_OUT ));
    BUFG BUFG_CLKOUT1  ( .I( SYS_CLK_CLKOUT1 ), .O( CLKOUT1     ));
    BUFG BUFG_CLKOUT2  ( .I( SYS_CLK_CLKOUT2 ), .O( CLKOUT2     ));
    BUFG BUFG_CLKOUT3  ( .I( SYS_CLK_CLKOUT3 ), .O( CLKOUT3     ));
    BUFG BUFG_CLKOUT4  ( .I( SYS_CLK_CLKOUT4 ), .O( CLKOUT4     ));

    localparam real CLK_IN_PERIOD_NS = 1000.0/(INPUT_CLOCK_FREQ/1_000_000.0);
  //localparam      CLK_MUL =  18
    localparam      CLK_MUL =  (INPUT_CLOCK_FREQ== 66_000_000) ? 18
                            :  (INPUT_CLOCK_FREQ==100_000_000) ? 14
                            :  (INPUT_CLOCK_FREQ==125_000_000) ? 15
                            :  (INPUT_CLOCK_FREQ==156_250_000) ? 6.4
                            : 1_000/(INPUT_CLOCK_FREQ/1_000_000);// 18.0  // 5~64
    localparam      CLK0_DIV= ((INPUT_CLOCK_FREQ/1_000_000)*CLK_MUL)/(SYSCLK_FREQ/1_000_000);
    localparam      CLK1_DIV= ((INPUT_CLOCK_FREQ/1_000_000)*CLK_MUL)/(CLKOUT1_FREQ/1_000_000)
                  , CLK2_DIV= ((INPUT_CLOCK_FREQ/1_000_000)*CLK_MUL)/(CLKOUT2_FREQ/1_000_000)
                  , CLK3_DIV= ((INPUT_CLOCK_FREQ/1_000_000)*CLK_MUL)/(CLKOUT3_FREQ/1_000_000)
                  , CLK4_DIV= ((INPUT_CLOCK_FREQ/1_000_000)*CLK_MUL)/(CLKOUT4_FREQ/1_000_000);

    MMCM_ADV #(.BANDWIDTH           ("LOW"     )
              ,.CLKIN1_PERIOD       (CLK_IN_PERIOD_NS)
              ,.CLKFBOUT_MULT_F     (CLK_MUL   )
              ,.DIVCLK_DIVIDE       (1         )
              ,.CLKFBOUT_PHASE      (0.0       )
              ,.CLKOUT0_DIVIDE_F    (CLK0_DIV  ) // SYS_CLK_OUT
              ,.CLKOUT0_DUTY_CYCLE  (0.5       )
              ,.CLKOUT0_PHASE       (0.0       )
              ,.CLKOUT1_DIVIDE      (CLK1_DIV  ) // CLKOUT1
              ,.CLKOUT1_DUTY_CYCLE  (0.5       )
              ,.CLKOUT1_PHASE       (0.0       )
              ,.CLKOUT2_DIVIDE      (CLK2_DIV  ) // CLKOUT2
              ,.CLKOUT2_DUTY_CYCLE  (0.5       )
              ,.CLKOUT2_PHASE       (0.0       )
              ,.CLKOUT3_DIVIDE      (CLK3_DIV  ) // CLKOUT3
              ,.CLKOUT3_DUTY_CYCLE  (0.5       )
              ,.CLKOUT3_PHASE       (0.0       )
              ,.CLKOUT4_CASCADE     ("FALSE"   )
              ,.CLKOUT4_DIVIDE      (CLK4_DIV  ) // CLKOUT4
              ,.CLKOUT4_DUTY_CYCLE  (0.5       )
              ,.CLKOUT4_PHASE       (0.0       )
              ,.CLKOUT5_DIVIDE      (16        ) // 
              ,.CLKOUT5_DUTY_CYCLE  (0.5       )
              ,.CLKOUT5_PHASE       (0.0       )
              ,.CLKOUT6_DIVIDE      (1         )
              ,.CLKOUT6_DUTY_CYCLE  (0.5       )
              ,.CLKOUT6_PHASE       (0.0       )
              ,.CLOCK_HOLD          ("FALSE"   )
              ,.REF_JITTER1         (0.0       )
              ,.STARTUP_WAIT        ("FALSE"   )
              ,.COMPENSATION        ("INTERNAL")
              ,.REF_JITTER2         (0.005     )
              ,.CLKIN2_PERIOD       (20.000    )
              ,.CLKFBOUT_USE_FINE_PS("FALSE"   )
              ,.CLKOUT0_USE_FINE_PS ("FALSE"   )
              ,.CLKOUT1_USE_FINE_PS ("FALSE"   )
              ,.CLKOUT2_USE_FINE_PS ("TRUE"    )
              ,.CLKOUT3_USE_FINE_PS ("FALSE"   )
              ,.CLKOUT4_USE_FINE_PS ("FALSE"   )
              ,.CLKOUT5_USE_FINE_PS ("FALSE"   )
              ,.CLKOUT6_USE_FINE_PS ("FALSE"   )
              )
    u_SYS_CLK (
        .CLKFBOUT        ( SYS_CLK_CLKFB    ),
        .CLKFBOUTB       (),
        .CLKOUT0         ( SYS_CLK_CLKOUT0  ),
        .CLKOUT0B        ( SYS_CLK_CLKOUT0B ),
        .CLKOUT1         ( SYS_CLK_CLKOUT1  ),
        .CLKOUT1B        ( SYS_CLK_CLKOUT1B ),
        .CLKOUT2         ( SYS_CLK_CLKOUT2  ),
        .CLKOUT2B        (),
        .CLKOUT3         ( SYS_CLK_CLKOUT3  ),
        .CLKOUT3B        (),
        .CLKOUT4         ( SYS_CLK_CLKOUT4  ),
        .CLKOUT5         (),
        .CLKOUT6         (),
        .LOCKED          ( SYS_CLK_LOCKED   ),
        .CLKFBIN         ( SYS_CLK_CLKFB    ),
        .CLKIN1          ( OSC_IN           ),
        .PWRDWN          ( 1'b0  ),
        .RST             ( 1'b0  ),
        .CLKIN2          ( 1'b0  ),
        .CLKINSEL        ( 1'b1  ),
        .CLKFBSTOPPED    (       ),
        .CLKINSTOPPED    (       ),
        .DCLK            ( 1'b0  ),
        .DEN             ( 1'b0  ),
        .DWE             ( 1'b0  ),
        .DRDY            (       ),
        .PSDONE          (       ),
        .DO              (       ),
        .PSCLK           ( 1'b0  ),
        .PSEN            ( 1'b0  ),
        .PSINCDEC        ( 1'b1  ),
        .DI              ( 16'h0 ),
        .DADDR           ( 7'h0  )
    );

    // synthesis translate_off
    //                  FVCO = 1000.0*CLKFBOUT_MULT_F/(CLKIN1_PERIOD*DIVCLK_DIVIDE);
    localparam real     FVCO = 1000.0*CLK_MUL/(CLK_IN_PERIOD_NS*1.0);
    localparam real     vco=INPUT_CLOCK_FREQ*CLK_MUL/(CLK_IN_PERIOD_NS*1);
    localparam integer  xx=CLK0_DIV;
    localparam real     aa=(CLK0_DIV-xx);
    localparam real     yy=((CLK0_DIV-xx)*1000.0);
    localparam integer  bb=yy;
    localparam integer  zz=(bb%125);
    initial begin
       if ((FVCO<600_000_000)||(1_200_000_000<FVCO)) $display("%m ERROR FVCO out of bound %f", FVCO);
       if ((CLK_MUL<5)||(64<CLK_MUL)) $display("%m ERROR CLKFBOUT_MULT_F out of bound: %d", CLK_MUL);
       if ((CLK0_DIV<2.0)||(128.0<CLK0_DIV)) $display("%m ERROR CLKOUT0_DIVIDE_F out of bound: %f", CLK0_DIV);
       if (yy) $display("%m ERROR CLK0_DIV increment should be 0.125, but %f", aa);
       if ((CLK1_DIV<1)||(128<CLK1_DIV)) $display("%m ERROR CLKOUT1_DIVIDE_F out of bound: %d", CLK1_DIV);
       if ((CLK2_DIV<1)||(128<CLK2_DIV)) $display("%m ERROR CLKOUT2_DIVIDE_F out of bound: %d", CLK2_DIV);
       if ((CLK3_DIV<1)||(128<CLK3_DIV)) $display("%m ERROR CLKOUT3_DIVIDE_F out of bound: %d", CLK3_DIV);
       if ((CLK4_DIV<1)||(128<CLK4_DIV)) $display("%m ERROR CLKOUT4_DIVIDE_F out of bound: %d", CLK4_DIV);
    end
    // synthesis translate_on

end else if (FPGA_FAMILY=="ZYNQ7000") begin: ZYNQ_CLKMGRA 

    wire CLKFBOUT;
    wire CLKFBIN=CLKFBOUT;
    wire SYS_CLK_CLKOUT0;
    wire SYS_CLK_CLKOUT1;
    wire SYS_CLK_CLKOUT2;
    wire SYS_CLK_CLKOUT3;
    wire SYS_CLK_CLKOUT4;

    BUFG BUFG_OSC_OUT  ( .I( OSC_IN          ), .O( OSC_OUT     ));
    BUFG BUFG_SYS_CLK  ( .I( SYS_CLK_CLKOUT0 ), .O( SYS_CLK_OUT ));
    BUFG BUFG_CLKOUT1  ( .I( SYS_CLK_CLKOUT1 ), .O( CLKOUT1     ));
    BUFG BUFG_CLKOUT2  ( .I( SYS_CLK_CLKOUT2 ), .O( CLKOUT2     ));
    BUFG BUFG_CLKOUT3  ( .I( SYS_CLK_CLKOUT3 ), .O( CLKOUT3     ));
    BUFG BUFG_CLKOUT4  ( .I( SYS_CLK_CLKOUT4 ), .O( CLKOUT4     ));

    localparam real CLK_IN_PERIOD_NS = 1000.0/(INPUT_CLOCK_FREQ/1_000_000.0);
    localparam      MUL  =  1_000/(INPUT_CLOCK_FREQ/1_000_000);// 18.0  // 5~64
    localparam      DIV  = ((INPUT_CLOCK_FREQ/1_000_000)*MUL)/(SYSCLK_FREQ/1_000_000); // 1.0~128.0
    localparam real CLK_MUL  = MUL
                  , CLK0_DIV = DIV;
    localparam      CLK1_DIV = ((INPUT_CLOCK_FREQ/1_000_000)*CLK_MUL)/(CLKOUT1_FREQ/1_000_000) //1~128
                  , CLK2_DIV = ((INPUT_CLOCK_FREQ/1_000_000)*CLK_MUL)/(CLKOUT2_FREQ/1_000_000)
                  , CLK3_DIV = ((INPUT_CLOCK_FREQ/1_000_000)*CLK_MUL)/(CLKOUT3_FREQ/1_000_000)
                  , CLK4_DIV = ((INPUT_CLOCK_FREQ/1_000_000)*CLK_MUL)/(CLKOUT4_FREQ/1_000_000);

    MMCME2_BASE #(.BANDWIDTH("OPTIMIZED"), // Jitter programming (OPTIMIZED, HIGH, LOW)
                  .CLKFBOUT_MULT_F(CLK_MUL), // Multiply value for all CLKOUT (2.000-64.000).
                  .CLKFBOUT_PHASE (0.0), // Phase offset in degrees of CLKFB (-360.000-360.000).
                  .CLKIN1_PERIOD  (CLK_IN_PERIOD_NS), // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
                  // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
                  .CLKOUT1_DIVIDE  (CLK1_DIV),
                  .CLKOUT2_DIVIDE  (CLK2_DIV),
                  .CLKOUT3_DIVIDE  (CLK3_DIV),
                  .CLKOUT4_DIVIDE  (CLK4_DIV),
                  .CLKOUT5_DIVIDE  (1),
                  .CLKOUT6_DIVIDE  (1),
                  .CLKOUT0_DIVIDE_F(CLK0_DIV), // Divide amount for CLKOUT0 (1.000-128.000).
                  // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
                  .CLKOUT0_DUTY_CYCLE(0.5),
                  .CLKOUT1_DUTY_CYCLE(0.5),
                  .CLKOUT2_DUTY_CYCLE(0.5),
                  .CLKOUT3_DUTY_CYCLE(0.5),
                  .CLKOUT4_DUTY_CYCLE(0.5),
                  .CLKOUT5_DUTY_CYCLE(0.5),
                  .CLKOUT6_DUTY_CYCLE(0.5),
                  // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
                  .CLKOUT0_PHASE(0.0),
                  .CLKOUT1_PHASE(0.0),
                  .CLKOUT2_PHASE(0.0),
                  .CLKOUT3_PHASE(0.0),
                  .CLKOUT4_PHASE(0.0),
                  .CLKOUT5_PHASE(0.0),
                  .CLKOUT6_PHASE(0.0),
                  .CLKOUT4_CASCADE("FALSE"), // Cascase CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
                  .DIVCLK_DIVIDE  (1), // Master division value (1-106)
                  .REF_JITTER1    (0.0), // Reference input jitter in UI (0.000-0.999).
                  .STARTUP_WAIT   ("FALSE") // Delays DONE until MMCM is locked (FALSE, TRUE)
                  )
    u_SYS_CLK (
                  // Clock Outputs: 1-bit (each) output: User configurable clock outputs
                  .CLKOUT0 (SYS_CLK_CLKOUT0), // 1-bit output: CLKOUT0
                  .CLKOUT0B(        ), // 1-bit output: Inverted CLKOUT0
                  .CLKOUT1 (SYS_CLK_CLKOUT1), // 1-bit output: CLKOUT1
                  .CLKOUT1B(        ), // 1-bit output: Inverted CLKOUT1
                  .CLKOUT2 (SYS_CLK_CLKOUT2), // 1-bit output: CLKOUT2
                  .CLKOUT2B(        ), // 1-bit output: Inverted CLKOUT2
                  .CLKOUT3 (SYS_CLK_CLKOUT3), // 1-bit output: CLKOUT3
                  .CLKOUT3B(        ), // 1-bit output: Inverted CLKOUT3
                  .CLKOUT4 (SYS_CLK_CLKOUT4), // 1-bit output: CLKOUT4
                  .CLKOUT5 (        ), // 1-bit output: CLKOUT5
                  .CLKOUT6 (        ), // 1-bit output: CLKOUT6
                  // Feedback Clocks: 1-bit (each) output: Clock feedback ports
                  .CLKFBOUT (CLKFBOUT), // 1-bit output: Feedback clock
                  .CLKFBOUTB(         ), // 1-bit output: Inverted CLKFBOUT
                  // Status Port: 1-bit (each) output: MMCM status ports
                  .LOCKED   (SYS_CLK_LOCKED), // 1-bit output: LOCK
                  // Clock Input: 1-bit (each) input: Clock input
                  .CLKIN1   (OSC_IN     ), // 1-bit input: Clock
                  // Control Ports: 1-bit (each) input: MMCM control ports
                  .PWRDWN   (1'b0), // 1-bit input: Power-down
                  .RST      (1'b0), // 1-bit input: Reset
                  // Feedback Clocks: 1-bit (each) input: Clock feedback ports
                  .CLKFBIN  (CLKFBIN) // 1-bit input: Feedback clock
    );
    // synthesis translate_off
    localparam integer  xx=CLK_MUL;
    localparam real     aa=(CLK_MUL-xx);
    localparam real     yy=((CLK_MUL-xx)*1000.0);
    localparam integer  bb=yy;
    localparam integer  zz=(bb%125);
    initial begin
       if ((CLK_MUL<2.0)||(64.0<CLK_MUL)) $display("%m ERROR CLKFBOUT_MULT_F out of bound: %f", CLK_MUL);
       if (zz) $display("%m ERROR CLKBOUT_MULT increment should be 0.125, but %f", aa);
       if ((CLK0_DIV<2.0)||(106.0<CLK0_DIV)) $display("%m ERROR DIVCLK_DIVIDE out of bound: %f", CLK0_DIV);
       if ((CLK1_DIV<1)||(128<CLK1_DIV)) $display("%m ERROR CLKOUT[1]_DIVIDE out of bound: %d", CLK1_DIV);
       if ((CLK1_DIV<2)||(128<CLK2_DIV)) $display("%m ERROR CLKOUT[2]_DIVIDE out of bound: %d", CLK2_DIV);
       if ((CLK1_DIV<3)||(128<CLK3_DIV)) $display("%m ERROR CLKOUT[3]_DIVIDE out of bound: %d", CLK3_DIV);
       if ((CLK1_DIV<4)||(128<CLK4_DIV)) $display("%m ERROR CLKOUT[4]_DIVIDE out of bound: %d", CLK4_DIV);
    end
    // synthesis translate_on
end
//------------------------------------------------------------------------------
else if ((FPGA_FAMILY=="VirtexUS" )||(FPGA_FAMILY=="VirtexUSP" ))
begin: XCVU_CLKMGRA 
    wire SYS_CLK_CLKFB   ;
    wire SYS_CLK_CLKOUT0 ;
    wire SYS_CLK_CLKOUT0B;
    wire SYS_CLK_CLKOUT1 ;
    wire SYS_CLK_CLKOUT1B;
    wire SYS_CLK_CLKOUT2 ;
    wire SYS_CLK_CLKOUT3 ;
    wire SYS_CLK_CLKOUT4 ;

    BUFG BUFG_OSC_OUT  ( .I( OSC_IN          ), .O( OSC_OUT     ));
    BUFG BUFG_SYS_CLK  ( .I( SYS_CLK_CLKOUT0 ), .O( SYS_CLK_OUT ));
    BUFG BUFG_CLKOUT1  ( .I( SYS_CLK_CLKOUT1 ), .O( CLKOUT1     ));
    BUFG BUFG_CLKOUT2  ( .I( SYS_CLK_CLKOUT2 ), .O( CLKOUT2     ));
    BUFG BUFG_CLKOUT3  ( .I( SYS_CLK_CLKOUT3 ), .O( CLKOUT3     ));
    BUFG BUFG_CLKOUT4  ( .I( SYS_CLK_CLKOUT4 ), .O( CLKOUT4     ));

    localparam real CLK_IN_PERIOD_NS = 1000.0/(INPUT_CLOCK_FREQ/1000000);
    localparam real CLK_MUL =  1_000.0/(INPUT_CLOCK_FREQ/1_000_000.0) // 18.0  // 5~64
                  , CLK_DIV = ((INPUT_CLOCK_FREQ/1000000)*CLK_MUL)/(SYSCLK_FREQ/1000000)
                  , CLK1_DIV= ((INPUT_CLOCK_FREQ/1000000)*CLK_MUL)/(CLKOUT1_FREQ/1000000)
                  , CLK2_DIV= ((INPUT_CLOCK_FREQ/1000000)*CLK_MUL)/(CLKOUT2_FREQ/1000000)
                  , CLK3_DIV= ((INPUT_CLOCK_FREQ/1000000)*CLK_MUL)/(CLKOUT3_FREQ/1000000)
                  , CLK4_DIV= ((INPUT_CLOCK_FREQ/1000000)*CLK_MUL)/(CLKOUT4_FREQ/1000000);

    //---------- MMCM -------------------------------------- 
    MMCME3_ADV #(
      .BANDWIDTH             ( "OPTIMIZED" ) // Jitter programming (OPTIMIZED, HIGH, LOW)
    , .CLKFBOUT_MULT_F       ( CLK_MUL     ) // Multiply value for all CLKOUT (2.000-64.000).
    , .CLKFBOUT_PHASE        ( 0.0         ) // Phase offset in degrees of CLKFB (-360.000-360.000).
    // CLKIN_PERIOD: Input clock period in ns units, ps resolution (i.e. 33.333 is 30 MHz).
    , .CLKIN1_PERIOD         ( CLK_IN_PERIOD_NS    )
    //, .CLKIN2_PERIOD         ( 0.0              )
    , .CLKOUT0_DIVIDE_F      ( CLK_DIV ) // Divide amount for CLKOUT0 (1.000-128.000).
    // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for CLKOUT outputs (0.001-0.999).
    , .CLKOUT0_DUTY_CYCLE    ( 0.5              )
    , .CLKOUT1_DUTY_CYCLE    ( 0.5              )
    , .CLKOUT2_DUTY_CYCLE    ( 0.5              )
    , .CLKOUT3_DUTY_CYCLE    ( 0.5              )
    , .CLKOUT4_DUTY_CYCLE    ( 0.5              )
    , .CLKOUT5_DUTY_CYCLE    ( 0.5              )
    , .CLKOUT6_DUTY_CYCLE    ( 0.5              )
    // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for CLKOUT outputs (-360.000-360.000).
    , .CLKOUT0_PHASE         ( 0.0              )
    , .CLKOUT1_PHASE         ( 0.0              )
    , .CLKOUT2_PHASE         ( 0.0              )
    , .CLKOUT3_PHASE         ( 0.0              )
    , .CLKOUT4_CASCADE       ( "FALSE"          )
    , .CLKOUT4_PHASE         ( 0.0              )
    , .CLKOUT5_PHASE         ( 0.0              )
    , .CLKOUT6_PHASE         ( 0.0              )
    // CLKOUT1_DIVIDE - CLKOUT6_DIVIDE: Divide amount for CLKOUT (1-128)
    , .CLKOUT1_DIVIDE        ( CLK1_DIV   )
    , .CLKOUT2_DIVIDE        ( CLK2_DIV   )
    , .CLKOUT3_DIVIDE        ( CLK3_DIV   )
    , .CLKOUT4_DIVIDE        ( CLK4_DIV   )
    , .CLKOUT5_DIVIDE        ( 16   )
    , .CLKOUT6_DIVIDE        ( 2   )
    , .COMPENSATION          ( "ZHOLD"          ) // AUTO, BUF_IN, EXTERNAL, INTERNAL, ZHOLD
    , .DIVCLK_DIVIDE         ( 1.0    ) // Master division value (1-106)
    // Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
    , .IS_CLKFBIN_INVERTED   ( 1'b0             ) // Optional inversion for CLKFBIN
    , .IS_CLKIN1_INVERTED    ( 1'b0             ) // Optional inversion for CLKIN1
    , .IS_CLKIN2_INVERTED    ( 1'b0             ) // Optional inversion for CLKIN2
    , .IS_CLKINSEL_INVERTED  ( 1'b0             ) // Optional inversion for CLKINSEL
    , .IS_PSEN_INVERTED      ( 1'b0             ) // Optional inversion for PSEN
    , .IS_PSINCDEC_INVERTED  ( 1'b0             ) // Optional inversion for PSINCDEC
    , .IS_PWRDWN_INVERTED    ( 1'b0             ) // Optional inversion for PWRDWN
    , .IS_RST_INVERTED       ( 1'b0             ) // Optional inversion for RST
    // REF_JITTER: Reference input jitter in UI (0.000-0.999).
    , .REF_JITTER1           ( 0.0              )
    , .REF_JITTER2           ( 0.0              )
    , .STARTUP_WAIT          ( "FALSE"          ) // Delays DONE until MMCM is locked (FALSE, TRUE)
    // Spread Spectrum: Spread Spectrum Attributes
    , .SS_EN                 ( "FALSE"          ) // Enables spread spectrum (FALSE, TRUE)
    , .SS_MODE               ( "CENTER_HIGH"    ) // CENTER_HIGH, CENTER_LOW, DOWN_HIGH, DOWN_LOW
    , .SS_MOD_PERIOD         ( 10000            ) // Spread spectrum modulation period (ns) (4000-40000)
    // USE_FINE_PS: Fine phase shift enable (TRUE/FALSE)
    , .CLKFBOUT_USE_FINE_PS  ( "FALSE"          )
    , .CLKOUT0_USE_FINE_PS   ( "FALSE"          )
    , .CLKOUT1_USE_FINE_PS   ( "FALSE"          )
    , .CLKOUT2_USE_FINE_PS   ( "FALSE"          )
    , .CLKOUT3_USE_FINE_PS   ( "FALSE"          )
    , .CLKOUT4_USE_FINE_PS   ( "FALSE"          )
    , .CLKOUT5_USE_FINE_PS   ( "FALSE"          )
    , .CLKOUT6_USE_FINE_PS   ( "FALSE"          )
    )
    u_SYS_CLK      (
    // Clock Inputs: 1-bit (each) input: Clock inputs
      .CLKIN1          ( OSC_IN          ) // 1-bit input: Primary clock
    , .CLKIN2          ( 1'b0            ) // 1-bit input: Secondary clock
    , .CLKINSEL        ( 1'b1            ) // 1-bit input: Clock select, High=CLKIN1 Low=CLKIN2
    , .CLKFBIN         ( SYS_CLK_CLKFB         ) // 1-bit input: Feedback clock
    , .RST             ( 1'b0         ) // 1-bit input: Reset
    , .PWRDWN          ( 1'b0            ) // 1-bit input: Power-down

    // Clock Outputs: 1-bit (each) output: User configurable clock outputs
    , .CLKFBOUT        ( SYS_CLK_CLKFB         ) // 1-bit output: Feedback clock
    , .CLKFBOUTB       (                 ) // 1-bit output: Inverted CLKFBOUT
    , .CLKOUT0         ( SYS_CLK_CLKOUT0         ) // 1-bit output: CLKOUT0
    , .CLKOUT0B        ( SYS_CLK_CLKOUT0B ) // 1-bit output: Inverted CLKOUT0
    , .CLKOUT1         ( SYS_CLK_CLKOUT1         ) // 1-bit output: Primary clock
    , .CLKOUT1B        ( SYS_CLK_CLKOUT1B               ) // 1-bit output: Inverted CLKOUT1
    , .CLKOUT2         ( SYS_CLK_CLKOUT2         ) // 1-bit output: CLKOUT2
    , .CLKOUT2B        (                 ) // 1-bit output: Inverted CLKOUT2
    , .CLKOUT3         ( SYS_CLK_CLKOUT3         ) // 1-bit output: CLKOUT3
    , .CLKOUT3B        (                 ) // 1-bit output: Inverted CLKOUT3
    , .CLKOUT4         ( SYS_CLK_CLKOUT4         ) // 1-bit output: CLKOUT4
    , .CLKOUT5         ( ) // 1-bit output: CLKOUT5
    , .CLKOUT6         ( ) // 1-bit output: CLKOUT6
    , .LOCKED          ( SYS_CLK_LOCKED          ) // 1-bit output: LOCK

    // Control Ports: 1-bit (each) input: MMCM control ports
    // DRP Ports: 7-bit (each) input: Dynamic reconfiguration ports
    , .DCLK            ( 1'b0            ) // 1-bit input: DRP clock
    , .DADDR           ( 7'h0            ) // 7-bit input: DRP address
    , .DEN             ( 1'b0            ) // 1-bit input: DRP enable
    , .DWE             ( 1'b0            ) // 1-bit input: DRP write enable
    , .DI              ( 16'h0           ) // 16-bit input: DRP data
    // DRP Ports: 16-bit (each) output: Dynamic reconfiguration ports
    , .DO              (                 ) // 16-bit output: DRP data
    , .DRDY            (                 ) // 1-bit output: DRP ready

    // Dynamic Phase Shift Ports: 1-bit (each) input: Ports used for dynamic phase shifting of the outputs
    , .PSCLK           ( 1'b0            ) // 1-bit input: Phase shift clock
    , .PSEN            ( 1'b0            ) // 1-bit input: Phase shift enable
    , .PSINCDEC        ( 1'b0            ) // 1-bit input: Phase shift increment/decrement
    // Dynamic Phase Shift Ports: 1-bit (each) output: Ports used for dynamic phase shifting of the outputs
    , .PSDONE          (                 ) // 1-bit output: Phase shift done

    // Feedback: 1-bit (each) output: Clock feedback ports
    // Status Ports: 1-bit (each) output: MMCM status ports
    , .CLKINSTOPPED    (                 ) // 1-bit output: Input clock stopped
    , .CLKFBSTOPPED    (                 ) // 1-bit output: Feedback clock stopped
    , .CDDCDONE        (                 ) // 1-bit output: Clock dynamic divide done
    , .CDDCREQ         (                 ) // 1-bit input: Request to dymanic divide clock
    // Feedback: 1-bit (each) input: Clock feedback ports
    );
end
//------------------------------------------------------------------------------
else if ((FPGA_FAMILY=="SPARTAN")||
         (FPGA_FAMILY=="SPARTAN6"))
begin: SPARTAN_CLKMGRA 

    wire         SYS_CLKdcm_2X;
    wire         SYS_CLKdcm_2X180;
    wire         SYS_CLKdcm_90;
    wire         SYS_CLKdcm_180;
    wire         SYS_CLKdcm_270;
    wire         SYS_CLKdcm_clk0;
    wire         SYS_CLKdcm_dv;
    wire         SYS_CLKdcm_fx;

    BUFG     BUFG_OSC_OUT  ( .I( OSC_IN          ), .O( OSC_OUT     ));
    BUFG     BUFG_SYS_CLK  ( .I( SYS_CLKdcm_fx   ), .O( SYS_CLK_OUT )); 
    BUFG     BUFG_CLKOUT1  ( .I( SYS_CLKdcm_clk0 ), .O( CLKOUT1     ));
    BUFG     BUFG_CLKOUT2  ( .I( SYS_CLKdcm_dv   ), .O( CLKOUT2     ));
    BUFG     BUFG_CLKOUT3  ( .I( SYS_CLKdcm_180  ), .O( CLKOUT3     ));
    BUFG     BUFG_CLKOUT4  ( .I( SYS_CLKdcm_2X   ), .O( CLKOUT4     ));

    localparam CLKFX_MULTIPLY=20;

    DCM #(.CLKFX_MULTIPLY(CLKFX_MULTIPLY)
         ,.CLKFX_DIVIDE  (INPUT_CLOCK_FREQ*CLKFX_MULTIPLY/SYSCLK_FREQ)
         ,.CLKDV_DIVIDE  (2)
         ,.CLKIN_PERIOD  (1_000_000_000.0/INPUT_CLOCK_FREQ)
         )
    u_SYS_CLK (
          .CLKFB     ( CLKOUT1          )
        , .CLKIN     ( OSC_IN           )
        , .DSSEN     ( 1'b0             )
        , .RST       ( 1'b0             )
        , .PSEN      ( 1'b0             )
        , .PSINCDEC  ( 1'b0             )
        , .PSCLK     ( 1'b0             )
        , .CLK0      ( SYS_CLKdcm_clk0  ) // F=Fin
        , .CLK90     ( SYS_CLKdcm_90    )
        , .CLK180    ( SYS_CLKdcm_180   )
        , .CLK270    ( SYS_CLKdcm_270   )
        , .CLK2X     ( SYS_CLKdcm_2X    ) // F=Fin*2
        , .CLK2X180  ( SYS_CLKdcm_2X180 )
        , .CLKDV     ( SYS_CLKdcm_dv    ) // F=Fin/CLKDV_DIVIDE
        , .CLKFX     ( SYS_CLKdcm_fx    ) // F=Fin*CLKFX_MULTIPLY/CLKFX_DIVIDE
        , .CLKFX180  (  )
        , .STATUS    (  )
        , .LOCKED    ( SYS_CLK_LOCKED   )
        , .PSDONE    (  )
    );
end
//------------------------------------------------------------------------------
else begin : BLK_DEFAULT
//synthesis translate_off
initial begin
$display("%m ERROR FPGA_FAMILY not defined");
$stop(2);
end
//synthesis translate_on
end
endgenerate

endmodule

//------------------------------------------------------------------------------
//Revision History:
//
// 2018.06.12: 'VIRTEX6_CLKMGRA' block added for Virtex-6
// 2018.06.06: Parameter check added by Ando Ki.
// 2018.03.12: Started by Ando Ki (adki@future-ds.com)
//------------------------------------------------------------------------------
`endif
