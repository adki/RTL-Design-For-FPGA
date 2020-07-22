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
   .....
   //------------------------------------------------------------
endmodule
