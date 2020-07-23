/*
 * Copyright (c) 2020 by Ando Ki.
 * All right reserved.
 *
 * http://www.future-ds.com
 * adki@future-ds.com
 *
 */
`timescale 1ns/1ns

module apb_gpio_tester (
       PRESETn, PCLK,
       PSEL,    PENABLE,
       PADDR,   PWRITE,
       PWDATA,  PRDATA
);
       // AMBA port
       // common signals
       input         PRESETn;
       input         PCLK;
       // selection signal
       output        PSEL;    reg        PSEL;
       output        PENABLE; reg        PENABLE;
       // slave related signals
       output [31:0] PADDR;  reg  [31:0] PADDR;
       output        PWRITE; reg         PWRITE;
       output [31:0] PWDATA; reg  [31:0] PWDATA;
       input  [31:0] PRDATA; wire [31:0] PRDATA;
   /*********************************************************/
   // GPIO CSR address
   localparam GPIO_A_ADDR = 32'h00;
   localparam GPIO_B_ADDR = 32'h20;
   //--------------------------------------------------------
   reg [31:0] addr;
   reg [31:0] data;

   initial begin
       PSEL    = 0;
       PENABLE = 0;
       PADDR   = 0;
       PWRITE  = 0;
       PWDATA  = 0;
       @ (posedge PCLK);
       wait (PRESETn==1'b0);
       wait (PRESETn==1'b1);
       repeat (10) @ (posedge PCLK);
       gpio_test(GPIO_A_ADDR);
       repeat (20) @ (posedge PCLK);
       $finish(2);
   end
   /*********************************************************/
   localparam CONTROL =8'h00,
              LINE    =8'h04,
              MASK    =8'h08,
              IRQ     =8'h0C,
              EDGE    =8'h10,
              POL     =8'h14;
   /*********************************************************/
   task gpio_test;
        input [7:0] addr;
   begin
       // initialize value check
       $display("Initial value check");
       apb_read(addr+CONTROL, 4, data); gpio_check("CONTROL", addr+CONTROL, data, 'h0);
       apb_read(addr+LINE   , 4, data); gpio_check("LINE   ", addr+LINE   , data, ~'h0);
       apb_read(addr+MASK   , 4, data); gpio_check("MASK   ", addr+MASK   , data, ~'h0);
       apb_read(addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data,  'h0);
       apb_read(addr+EDGE   , 4, data); gpio_check("EDGE   ", addr+EDGE   , data,  'h0);
       apb_read(addr+POL    , 4, data); gpio_check("POL    ", addr+POL    , data,  'h0);

       // initialization
       $display("Initialzation");
       apb_write(addr+CONTROL, 4, 32'h0000_0000); // all input
       apb_write(addr+LINE   , 4, 32'hAAAA_5555);
       apb_write(addr+CONTROL, 4, 32'hFFFF_0000); // half-output(high) half-input(low)
       apb_read (addr+LINE   , 4, data); gpio_check("LINE   ", addr+LINE   , data, 32'hAAAA_FFFF);
       apb_read (addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data, 32'h0000_0000);
       repeat (5) @ (posedge PCLK);

       $display("Interrupt test: active-low level");
       apb_write(addr+CONTROL, 4, 32'h0000_0000); // all input (mind that GPIO_OUT-->GPIO_IN for output)
       apb_read (addr+LINE   , 4, data); gpio_check("LINE   ", addr+LINE   , data, 32'hFFFF_FFFF);
       apb_write(addr+LINE   , 4, 32'hAAAA_5555);
       apb_write(addr+CONTROL, 4, 32'h0000_FFFF); // half-input(high) half-output(low)
       apb_read (addr+LINE   , 4, data); gpio_check("LINE   ", addr+LINE   , data, 32'hFFFF_5555);
       apb_write(addr+MASK   , 4, 32'h0000_0000); // all irq enabled
       apb_read (addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data, ~32'hFFFF_5555);
       apb_write(addr+MASK   , 4, 32'hFFFF_FFFF);
       apb_write(addr+IRQ    , 4, 32'h0000_0000);
       apb_read (addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data, 32'h0000_0000);

       $display("Interrupt test: active-high level");
       apb_write(addr+CONTROL, 4, 32'hFFFF_FFFF); // all output (mind that GPIO_OUT-->GPIO_IN for output)
       apb_write(addr+LINE   , 4, 32'h1234_5678);
       apb_read (addr+LINE   , 4, data); gpio_check("LINE   ", addr+LINE   , data, 32'h1234_5678);
       apb_write(addr+POL    , 4, 32'hFFFF_FFFF); // active-high
       apb_write(addr+MASK   , 4, 32'h0000_0000); // all irq enabled
       apb_read (addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data, 32'h1234_5678);
       apb_write(addr+MASK   , 4, 32'hFFFF_FFFF);
       apb_write(addr+IRQ    , 4, 32'h0000_0000);
       apb_read (addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data, 32'h0000_0000);

       $display("Interrupt test: rising-edge");
       apb_write(addr+CONTROL, 4, 32'hFFFF_FFFF); // all output (mind that GPIO_OUT-->GPIO_IN for output)
       apb_write(addr+LINE   , 4, 32'h0000_0000);
       apb_write(addr+EDGE   , 4, 32'hFFFF_FFFF); // edge-sensitive
       apb_write(addr+POL    , 4, 32'hFFFF_FFFF); // rising-edge
       apb_write(addr+MASK   , 4, 32'h0000_0000); // all irq enabled
       apb_write(addr+LINE   , 4, 32'h1234_5678);
       apb_read (addr+LINE   , 4, data); gpio_check("LINE   ", addr+LINE   , data, 32'h1234_5678);
       apb_read (addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data, 32'h1234_5678);
       apb_write(addr+MASK   , 4, 32'hFFFF_FFFF);
       apb_write(addr+IRQ    , 4, 32'h0000_0000);
       apb_read (addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data, 32'h0000_0000);

       apb_write(addr+MASK   , 4, 32'h0000_0000);
       apb_write(addr+LINE   , 4,~32'h1234_5678);
       apb_read (addr+LINE   , 4, data); gpio_check("LINE   ", addr+LINE   , data,~32'h1234_5678);
       apb_read (addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data,~32'h1234_5678);
       apb_write(addr+MASK   , 4, 32'hFFFF_FFFF);
       apb_write(addr+IRQ    , 4, 32'h0000_0000);
       apb_read (addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data, 32'h0000_0000);

       $display("Interrupt test: fall-edge");
       apb_write(addr+CONTROL, 4, 32'hFFFF_FFFF); // all output (mind that GPIO_OUT-->GPIO_IN for output)
       apb_write(addr+LINE   , 4, 32'hFFFF_FFFF);
       apb_write(addr+EDGE   , 4, 32'hFFFF_FFFF); // edge-sensitive
       apb_write(addr+POL    , 4, 32'h0000_0000); // rising-edge
       apb_write(addr+MASK   , 4, 32'h0000_0000); // all irq enabled
       apb_write(addr+LINE   , 4, 32'h1234_5678);
       apb_read (addr+LINE   , 4, data); gpio_check("LINE   ", addr+LINE   , data, 32'h1234_5678);
       apb_read (addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data,~32'h1234_5678);
       apb_write(addr+MASK   , 4, 32'hFFFF_FFFF);
       apb_write(addr+IRQ    , 4, 32'h0000_0000);
       apb_read (addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data, 32'h0000_0000);

       apb_write(addr+MASK   , 4, 32'h0000_0000);
       apb_write(addr+LINE   , 4,~32'h1234_5678);
       apb_read (addr+LINE   , 4, data); gpio_check("LINE   ", addr+LINE   , data,~32'h1234_5678);
       apb_read (addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data, 32'h1234_5678);
       apb_write(addr+MASK   , 4, 32'hFFFF_FFFF);
       apb_write(addr+IRQ    , 4, 32'h0000_0000);
       apb_read (addr+IRQ    , 4, data); gpio_check("IRQ    ", addr+IRQ    , data, 32'h0000_0000);
   end
   endtask
   /*********************************************************/
   task     gpio_check;
            input [8*8-1:0] str;
            input [31:0]    addr;
            input [31:0]    value;
            input [31:0]    expect;
   begin
      $write("%m %07s at A:0x%08X ", str, addr);
      if (value!==expect) begin
          $display("D:0x%08X, but 0x%08X expected", value, expect);
      end else begin
          $display("D:0x%08X OK", value);
      end
   end
   endtask
   /*********************************************************/
   `include "apb_tasks.v"

endmodule
