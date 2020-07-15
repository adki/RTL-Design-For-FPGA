#ifndef MEM_API_H
#define MEM_API_H
//------------------------------------------------------------------------------
// Copyright (c) 2018 by Future Design Systems
// All right reserved.
// http://www.future-ds.com
//------------------------------------------------------------------------------
// mem_api.h
//------------------------------------------------------------------------------
// VERSION = 2018.04.27.
//------------------------------------------------------------------------------
#ifdef __cplusplus
extern "C" {
#endif

extern void mem_test(unsigned saddr, unsigned depth, int level);
extern int  MemTestRAW(unsigned saddr, unsigned depth, unsigned size);
extern int  MemTestBurstRAW(unsigned saddr, unsigned depth, unsigned leng);
extern int  MemTestAddWr(unsigned saddr, unsigned depth);
extern int  MemTestAddRr(unsigned saddr, unsigned depth);
extern int  MemTestAddRAW(unsigned saddr, unsigned depth);

#ifdef __cplusplus
}
#endif

//------------------------------------------------------------------------------
// Revision History
//
// 2018.04.27: Start by Ando Ki (adki@future-ds.com)
//------------------------------------------------------------------------------
#endif
