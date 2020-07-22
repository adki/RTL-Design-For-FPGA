//--------------------------------------------------------
// Copyright (c) 2018 by Future Design Systems Co., Ltd.
// All right reserved.
//
// http://www.future-ds.com
//--------------------------------------------------------
// VERSION = 2018.01.08.
//--------------------------------------------------------
//
// CONTROL: contols mode of each bit
//          - 0 for input, 1 for output
//          - default: 0x00000000
// LINE   : current value when read, drive value when write
// MASK   : interrupt mask
//          - 0 for enable, 1 for disable
//          - default: 0xFFFFFFFF
// IRQ    : interrupt status
//          - 1 for interrupt, 0 for normal
//          - default: 0x00000000
// EDGE   : edge/level sensitivity mode
//          - 0 for level, 1 for edge
//          - default: 0x00000000
// POL    : rising/falling/high/low mode
//          - 0 for active-low for level, falling-edge for edge
//          - 1 for active-high for level, rising-edge for edge
//          - default: 0x00000000
//--------------------------------------------------------
#include "trx_axi_api.h"
#include "gpio_api.h"

//--------------------------------------------------------
// Register access macros
#if defined(TRX_BFM)||defined(TRX_AXI)||defined(TRX_AHB)
#       define REGWR(A, B)        BfmWrite(handle, (unsigned int)(A), &(B), 4, 1)
#       define REGRD(A, B)        BfmRead (handle, (unsigned int)(A), &(B), 4, 1)
#	define   uart_put_string(x)  printf("%s", (x));
#	define   uart_put_hex(n)  printf("%x", (n));
#else
#       define REGWR(A, B)   *(unsigned *)A = B;
#       define REGRD(A, B)    B = *(unsigned *)A;
#	define   uart_put_string(x)  printf("%s", (x));
#	define   uart_put_hex(n)  printf("%x", (n));
#endif

//--------------------------------------------------------
extern con_Handle_t handle;

//--------------------------------------------------------
#ifndef ADDR_GPIO_START
//#warning  ADDR_GPIO_START should be defined
#define ADDR_GPIO_START 0x00000000
#endif

#define GPIO_CONTROL (ADDR_GPIO_START+0x00)
#define GPIO_LINE    (ADDR_GPIO_START+0x04)
#define GPIO_MASK    (ADDR_GPIO_START+0x08)
#define GPIO_IRQ     (ADDR_GPIO_START+0x0C)
#define GPIO_EDGE    (ADDR_GPIO_START+0x10)
#define GPIO_POL     (ADDR_GPIO_START+0x14)

//--------------------------------------------------------
uint32_t gpio_read(void) {
   uint32_t value;
   REGRD(GPIO_LINE, value);
   return value;
}

//--------------------------------------------------------
void gpio_write(uint32_t value) {
   REGWR(GPIO_LINE, value);
}

//--------------------------------------------------------
// level  = 0: level,   1: edge
// pol    = 0: falling, 1: rising
// enable = 0: disable, 1: enable
void gpio_interrupt_set(uint32_t edge, uint32_t pol, uint32_t enable) {
   uint32_t xval;
   REGWR(GPIO_EDGE, edge); // 0: level, 1: edge
   REGWR(GPIO_POL, pol); // 0: falling, 1: rising
   xval = ~enable;
   REGWR(GPIO_MASK, xval); // 0: enable, 1: masking-out
   REGRD(GPIO_MASK, xval);
}

//--------------------------------------------------------
// Interrtup enabled when 1, mask when 0.
// Note that interrupt disabled when 1
// Return result.
uint32_t gpio_irq_enable(uint32_t value) {
   uint32_t xval = ~value;
   REGWR(GPIO_MASK, xval);
   REGRD(GPIO_MASK, xval);
   return xval;
}

//--------------------------------------------------------
// 0: for level
// 1: for edge
uint32_t gpio_irq_edge(uint32_t value) {
   REGWR(GPIO_EDGE, value);
   REGRD(GPIO_EDGE, value);
   return value;
}

//--------------------------------------------------------
// 0: for active-low for level or falling for edge
// 1: for active-high for level or rising for edge
uint32_t gpio_irq_pol(uint32_t value) {
   REGWR(GPIO_POL, value);
   REGRD(GPIO_POL, value);
   return value;
}

//--------------------------------------------------------
// It returns 'IRQ' register value
uint32_t gpio_irq_read(void) {
   uint32_t value;
   REGRD(GPIO_IRQ, value);
   return value;
}

//--------------------------------------------------------
// Clear 'IRQ' bit according to bit value of 'value'.
// Bit value '0' of 'value' clear corresponding bit of 'IRQ'.
// Return result.
uint32_t gpio_irq_clear(uint32_t value) {
   uint32_t irq;
   REGRD(GPIO_IRQ, irq);
   irq &=  value;
   REGWR(GPIO_IRQ, irq);
   REGRD(GPIO_IRQ, value);
   return value;
}

//--------------------------------------------------------
// Default: gpio_init(0, 0, ~0, 0)
// inout      = 0: input,       1: output
// level      = 0: level,       1: edge
// pol        = 0: low/falling, 1: high/rising
// irq_enable = 0: disable,     1: enable
void gpio_init( uint32_t inout // 0 by default, all input mode
              , uint32_t edge  // 0 by default, all level-sesitive
              , uint32_t pol   //~0 by default, all active-high
              , uint32_t irq_enable) // 0 by default, all disabled
{
   uint32_t value;
   value = 0;
   REGWR(GPIO_CONTROL,inout); // all input mode
   REGWR(GPIO_LINE,   value); // all output value 0
   REGWR(GPIO_EDGE,   edge); // 0: level, 1: edge
   REGWR(GPIO_POL,    pol); // 0: low/falling, 1: high/rising
   value = ~irq_enable;
   REGWR(GPIO_MASK, value); // 0: enable, 1: masking-out
}

//--------------------------------------------------------
#undef REGWR
#undef REGRD

//--------------------------------------------------------
// Revision History
//
// 2018.01.08: Re-written by Ando Ki (adki@future-ds.com)
//             Need verification.
//--------------------------------------------------------
