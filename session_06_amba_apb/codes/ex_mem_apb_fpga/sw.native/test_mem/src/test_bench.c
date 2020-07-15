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
#include "mem_api.h"
//------------------------------------------------------
int test_memory = 0;
unsigned int mem_start  = 0x00000000; // APB mem
unsigned int mem_length = 0x100;
int level=0;
extern con_Handle_t handle;

// -----------------------------------------------------
void test_bench( void )
{
   printf("test_bench()\n"); fflush(stdout);

   unsigned int n, m;
   printf("Enter number to test (0 for infinite loop): "); fflush(stdout);
   scanf("%d", &n);

   int ret = BfmSetAmbaAxi4(handle);
   if (ret<0) {
       printf("something went wrong to set burst length\n");
       return;
   }
   printf("AMBA AXI burst length: %d\n", ret);

printf("Enter to start: "); fflush(stdout); getchar(); getchar();
   if (n==0) m = 1;
   else      m = n;
   while (m--) {
       if (test_memory) mem_test(mem_start, mem_length, level);
       if (n==0) m = 1;
   }
}
//------------------------------------------------------------------------------
// Revision History
//
// 2018.04.27: Start by Ando Ki (adki@future-ds.com)
//------------------------------------------------------------------------------
