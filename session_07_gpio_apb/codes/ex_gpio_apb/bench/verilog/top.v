//--------------------------------------------------------
// Copyright (c) 2020 by Ando Ki.
// All right reserved.
//
// http://www.future-ds.com
// adki@future-ds.com
//--------------------------------------------------------
`timescale 1ns/1ns

module top ;
   //--------------------------------------------------------
   localparam GPIO_WIDTH=32;
   //--------------------------------------------------------
   reg                         PRESETn;
   reg                         PCLK;
   wire                  #(1)  PSEL;
   wire                  #(1)  PENABLE;
   wire [31:0]           #(1)  PADDR;
   wire                  #(1)  PWRITE;
   wire [31:0]           #(1)  PWDATA;
   wire [31:0]           #(1)  PRDATA;
   wire [GPIO_WIDTH-1:0] #(1)  GPIO;
   wire [GPIO_WIDTH-1:0] #(1)  GPIO_I;
   wire [GPIO_WIDTH-1:0] #(1)  GPIO_O;
   wire [GPIO_WIDTH-1:0] #(1)  GPIO_T;
   wire                  #(1)  IRQ;
   //--------------------------------------------------------
   pullup UPA[GPIO_WIDTH-1:0](GPIO);
   assign GPIO_I = GPIO;
   generate
   genvar idx;
   for (idx=0; idx<GPIO_WIDTH; idx=idx+1) begin: DIX
        assign GPIO[idx] = (GPIO_T[idx]) ? 1'bZ : GPIO_O[idx];
   end
   endgenerate
   //--------------------------------------------------------
   apb_gpio_tester u_tester (
       .PRESETn (PRESETn)
      ,.PCLK    (PCLK   )
      ,.PSEL    (PSEL   )
      ,.PENABLE (PENABLE)
      ,.PADDR   (PADDR  )
      ,.PWRITE  (PWRITE )
      ,.PWDATA  (PWDATA )
      ,.PRDATA  (PRDATA )
   );
   //--------------------------------------------------------
   gpio_apb #(.GPIO_WIDTH(GPIO_WIDTH))
   u_gpio (
         .PRESETn  (PRESETn )
       , .PCLK     (PCLK    )
       , .PSEL     (PSEL    )
       , .PENABLE  (PENABLE )
       , .PADDR    (PADDR   )
       , .PWRITE   (PWRITE  )
       , .PWDATA   (PWDATA  )
       , .PRDATA   (PRDATA  )
       , .GPIO_I   (GPIO_I  )
       , .GPIO_O   (GPIO_O  )
       , .GPIO_T   (GPIO_T  )
       , .IRQ      (IRQ     )
   );
   //--------------------------------------------------------
   always #5 PCLK <= ~PCLK;
   initial begin
       PCLK    = 0;
       PRESETn = 0;
       repeat (20) @ (posedge PCLK);
       PRESETn = 1;
       repeat (10) @ (posedge PCLK);
   end
   //--------------------------------------------------------
`ifdef VCD
   initial begin
       $dumpfile("wave.vcd"); //$dumplimit(1000000);
       $dumpvars(0);
   end
`endif
endmodule
