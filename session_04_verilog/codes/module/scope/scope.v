`timescale 1ns/1ns
module top;
   reg [31:0] my_id;
   initial my_id = 100;
   mod_A UA();
   function [31:0] get_my_id;
      get_my_id = my_id; // how to find 'my_id'
   endfunction
   task put_my_id;
      $display($time,,"%m: my_id is %d", my_id);
   endtask
endmodule

module mod_A;
   reg   [31:0] mid_id;
   initial mid_id = 200;
   mod_B UB();
endmodule

module mod_B;
   reg   [31:0] local_id;
   initial begin : C
      local_id = 1;
      #100; put_id(); // how to find 'get_my_id()'
      #100; put_my_id(); // how to find 'get_my_id()'
      #100; local_id = get_my_id(); // how to find 'get_my_id()'
      #100; put_id(); // how to find 'get_my_id()'
      #100; $display($time,,"%m: mid_id   %d", mod_A.mid_id);
      #100;
      $finish;
   end
   task put_id;
      $display($time,,"%m: id is    %d", local_id); // how to find 'local_id'
   endtask
endmodule
