`ifndef APB_TASKS_V
`define APB_TASKS_V
/*
 * Copyright (c) 2020 by Ando Ki.
 * All right reserved.
 *
 * http://www.future-ds.com
 * adki@future-ds.com
 *
 */

   // generate a read transaction for 1 byte on AMBA APB
   // apb_read(address, size, data)
   task apb_read;
        input  [31:0] address;
        input  [2:0]  size;
        output [31:0]  data;
        begin
          ..............
        end
   endtask

   // generate a write transaction for 1 byte on AMBA APB
   // apb_write(address, size, data)
   task apb_write;
        input  [31:0] address;
        input  [2:0]  size;
        input  [31:0]  data;
        begin
          .............
        end
   endtask
`endif
