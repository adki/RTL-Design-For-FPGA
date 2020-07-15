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
   ... fill your code using bram ...
   //-----------------------------------------------------
endmodule
