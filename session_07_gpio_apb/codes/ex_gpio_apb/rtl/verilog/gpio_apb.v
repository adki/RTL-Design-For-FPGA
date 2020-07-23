//--------------------------------------------------------
// Copyright (c) 2018 by Future Design Systems
// All right reserved.
//
// http://www.future-ds.com
//--------------------------------------------------------
// VERSION = 2018.04.19.
//--------------------------------------------------------
// gpio_apb.v
//--------------------------------------------------------
// [REGISTERS]
// 0x00: Line Control Register
//       '0' = input mode (default)
//       '1' = output mode
// 0x04: Line Register
//       Current GPIO pin level
// 0x08: Interrupt Mask Register
//       '0' = enabled
//       '1' = masked (disabled) (default)
// 0x0C: Interrupt Flag
// 0x10: Interrupt Edge/Level Sensitivity Mode Register
//       '0' = Level sensitivity mode (default)
//       '1' = Edge sensitivity mode
// 0x14: Interrupt Pol Sensitivity Mode Register
//       '0' = active-low for level mode, falling for edge mode (default)
//       '1' = active-high for level mode, rising for edge mode
//
// [HOWTO]
// * Use a pin as an input:
//   Program the corresponding bit in the Control Register
//   to 'input mode' ('0').
//   Then, the pin's state (input level) can be checked
//   by reading the Line Register.
//   Note that writing to the GPIO pin's Line Register bit
//   while in input mode has no effect.
//
// * Use a pin as an output:
//   Program the corresponding bit in the Control Register
//   to 'output mode' ('1').
//   Then, program the GPIO pin's output level by writing
//   to the corresponding bit in the Line Register.
//   Note reading the GPIO pin's Line Register bit while
//   in output mode returns the current input pin level
//   so that it may not reflect the value written.
//
// * Use a pin as an interrupt source:
//   Program the corresponding bit in the Edge Register
//   to the desired sensitivity mode (level or edge).
//   Program the corresponding bit in the Pol Register
//   to the desired sensitivity mode (low/falling or high/rising).
//   Program the corresponding bit in the Mask Register
//   to 'un-masked mode' ('0').
//--------------------------------------------------------
module gpio_apb #(parameter GPIO_WIDTH=32)
(
       input   wire                  PRESETn
     , input   wire                  PCLK
     , input   wire                  PSEL
     , input   wire                  PENABLE
     , input   wire [31:0]           PADDR
     , input   wire                  PWRITE
     , output  reg  [31:0]           PRDATA
     , input   wire [31:0]           PWDATA
     , input   wire [GPIO_WIDTH-1:0] GPIO_I
     , output  wire [GPIO_WIDTH-1:0] GPIO_O
     , output  wire [GPIO_WIDTH-1:0] GPIO_T 
     , output  wire                  IRQ
);
   //------------------------------------------------------------
   localparam CSRA_CONTROL = 8'h00,
              CSRA_LINE    = 8'h04,
              CSRA_MASK    = 8'h08,
              CSRA_IRQ     = 8'h0C,
              CSRA_EDGE    = 8'h10,
              CSRA_POL     = 8'h14;
   //------------------------------------------------------------
   reg  [GPIO_WIDTH-1:0] csr_line_out = {GPIO_WIDTH{1'b0}}; // all clear
   reg  [GPIO_WIDTH-1:0] csr_control  = {GPIO_WIDTH{1'b0}}; // all input
   reg  [GPIO_WIDTH-1:0] csr_mask     = {GPIO_WIDTH{1'b1}}; // all masked
   reg  [GPIO_WIDTH-1:0] csr_irq      = {GPIO_WIDTH{1'b0}}; // all clear
   reg  [GPIO_WIDTH-1:0] csr_edge     = {GPIO_WIDTH{1'b0}}; // all level
   reg  [GPIO_WIDTH-1:0] csr_pol      = {GPIO_WIDTH{1'b1}}; // all active high
   //------------------------------------------------------------
   assign GPIO_O  = csr_line_out;
   assign GPIO_T  = ~csr_control; // 0 output, 1 input
   assign IRQ     = |csr_irq;
   //------------------------------------------------------------
   // CSR read
   //always @ (PWRITE or PSEL or PADDR) begin
   always @ (*) begin
       if (~PWRITE&PSEL) begin
          PRDATA = 'h0;
          case (PADDR[7:0]) // synopsys parallel_case full_case
              CSRA_CONTROL: PRDATA[GPIO_WIDTH-1:0] = csr_control;
              CSRA_LINE   : PRDATA[GPIO_WIDTH-1:0] = GPIO_I;
              CSRA_MASK   : PRDATA[GPIO_WIDTH-1:0] = csr_mask;
              CSRA_IRQ    : PRDATA[GPIO_WIDTH-1:0] = csr_irq;
              CSRA_EDGE   : PRDATA[GPIO_WIDTH-1:0] = csr_edge;
              CSRA_POL    : PRDATA[GPIO_WIDTH-1:0] = csr_pol;
              default     : PRDATA                 = 'h0;
          endcase
       end else begin
          PRDATA = 'h0;
       end
   end
   //------------------------------------------------------------
   always @ (posedge PCLK or negedge PRESETn) begin
     if (PRESETn==1'b0) begin
       csr_line_out <= {GPIO_WIDTH{1'b0}}; // all clear
       csr_control  <= {GPIO_WIDTH{1'b0}}; // all input
       csr_mask     <= {GPIO_WIDTH{1'b1}}; // all masked
       csr_edge     <= {GPIO_WIDTH{1'b0}}; // all level
       csr_pol      <= {GPIO_WIDTH{1'b1}}; // all active high
     end else begin
        if (PWRITE&PSEL&PENABLE) begin
            case (PADDR[7:0]) // synopsys parallel_case full_case
            CSRA_CONTROL: csr_control  <= PWDATA[GPIO_WIDTH-1:0];
            CSRA_LINE   : csr_line_out <= PWDATA[GPIO_WIDTH-1:0];
            CSRA_MASK   : csr_mask     <= PWDATA[GPIO_WIDTH-1:0];
            CSRA_EDGE   : csr_edge     <= PWDATA[GPIO_WIDTH-1:0];
            CSRA_POL    : csr_pol      <= PWDATA[GPIO_WIDTH-1:0];
            default     : begin end
            endcase
         end
     end
   end
   //------------------------------------------------------------
   reg [GPIO_WIDTH-1:0] gpio_d, gpio_dx; // delayed
   always @ (posedge PCLK or negedge PRESETn) begin
     if (PRESETn==1'b0) begin
         gpio_d  <= {GPIO_WIDTH{1'b0}}; //GPIO_I;
         gpio_dx <= {GPIO_WIDTH{1'b0}}; //GPIO_I;
     end else begin
         gpio_d  <= gpio_dx;
         gpio_dx <= GPIO_I;
     end
   end
   //------------------------------------------------------------
   // Note that it is two-cycle width in order to prevent missing
   // edge while 'csr_irq' is wrriten.
   wire   [GPIO_WIDTH-1:0] gpio_fall; // falling-edge
   wire   [GPIO_WIDTH-1:0] gpio_rise; // falling-edge
   assign gpio_fall = ~GPIO_I& gpio_d;
   assign gpio_rise =  GPIO_I&~gpio_d;
   //------------------------------------------------------------
   wire [GPIO_WIDTH-1:0] event_edge;
   assign event_edge = (csr_edge&csr_pol&gpio_rise)|(csr_edge&(~csr_pol)&gpio_fall);
   //------------------------------------------------------------
   wire [GPIO_WIDTH-1:0] event_level;
   assign event_level = ((~csr_edge)&csr_pol&GPIO_I)|((~csr_edge)&(~csr_pol)&(~GPIO_I));
   //------------------------------------------------------------
   wire [GPIO_WIDTH-1:0] event_irq;
   assign event_irq = (~csr_mask)&(event_edge|event_level);
   //------------------------------------------------------------
   always @ (posedge PCLK or negedge PRESETn) begin
     if (PRESETn==1'b0) begin
       csr_irq <= {GPIO_WIDTH{1'b0}}; // all clear
     end else begin
        if (PWRITE&PSEL&PENABLE&(PADDR[7:0]==CSRA_IRQ)) begin
            csr_irq <= csr_irq & PWDATA[GPIO_WIDTH-1:0]; // bit-value 0 will clear irq
        end else begin
            csr_irq <= csr_irq | event_irq;
        end
     end
   end
   //------------------------------------------------------------
endmodule
//--------------------------------------------------------
// Revision history
//
// 2018.04.19: active-high with level-sensitivity by default.
//--------------------------------------------------------
