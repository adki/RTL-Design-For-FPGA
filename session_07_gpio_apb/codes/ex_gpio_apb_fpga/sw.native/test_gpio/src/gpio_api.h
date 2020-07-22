#ifndef _GPIO_API_H_
#	define _GPIO_API_H_
//--------------------------------------------------------
// Copyright (c) 2018 by Future Design Systems Co., Ltd.
// All right reserved.
//
// http://www.future-ds.com
//--------------------------------------------------------
// VERSION = 2018.08.31.
//--------------------------------------------------------

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

extern void     gpio_init( uint32_t inout // 0 by default, all input mode
                         , uint32_t edge  // 0 by default, all level-sesitive
                         , uint32_t pol   //~0 by default, all active-high
                         , uint32_t irq_enable); //0 by default, all disabled
extern uint32_t gpio_read            (void);
extern void     gpio_write           (uint32_t value);
extern void     gpio_interrupt_set(uint32_t edge, uint32_t pol, uint32_t enable);
extern uint32_t gpio_irq_clear       (uint32_t value);

#ifdef __cplusplus
}
#endif
//--------------------------------------------------------
// Revision History
//
// 2018.: Start by Ando Ki (adki@future-ds.com)
//--------------------------------------------------------
#endif
