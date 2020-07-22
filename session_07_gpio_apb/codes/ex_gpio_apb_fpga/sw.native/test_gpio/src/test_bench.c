//------------------------------------------------------------------------------
// Copyright (c) 2011 by Future Design Systems Co., Ltd.
// All right reserved.
//
// http://www.future-ds.com
//------------------------------------------------------------------------------
// VERSION = 2011.11.22.
//------------------------------------------------------------------------------
#include <stdio.h>
#include "trx_axi_api.h"
#include "gpio_api.h"
//------------------------------------------------------
int level=0;
extern con_Handle_t handle;

// -----------------------------------------------------
void test_bench( void )
{
   printf("test_bench()\n"); fflush(stdout);

   int ret = BfmSetAmbaAxi4(handle);
   if (ret<0) {
       printf("something went wrong to set burst length\n");
       return;
   }
   unsigned int gpio_control= 0x000000F0; // bit[7:4]=LED, bit[3:0]=SW
   unsigned int gpio_edge   = 0x00000000; // all level sesitive
   unsigned int gpio_pol    =~0x00000000; // all active-high
   unsigned int gpio_irq    =~0x00000000; // all enabled
   gpio_init(gpio_control, gpio_edge, gpio_pol, gpio_irq);

   unsigned int gpio_LED=0;
   gpio_LED = gpio_read()&0xF0;
   do { unsigned int gpio_in;
        gpio_in   = gpio_read()&0xF;
        gpio_LED ^= gpio_in<<4;
        gpio_write(gpio_LED);
   } while (1);
}
//------------------------------------------------------------------------------
// Revision History
//
// 2018.04.27: Start by Ando Ki (adki@future-ds.com)
//------------------------------------------------------------------------------
