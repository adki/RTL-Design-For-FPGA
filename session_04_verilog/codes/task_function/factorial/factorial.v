module top;
 // define an automatic function
 function automatic integer factorial_auto;
    input [31:0] operand;
    integer i;
    if (operand >= 2) factorial_auto = factorial_auto(operand - 1) * operand;
    else factorial_auto = 1;
 endfunction

 // define the function
 function integer factorial;
    input [31:0] operand;
    integer i;
    if (operand >= 2) factorial = factorial(operand - 1) * operand;
    else factorial = 1;
 endfunction
 
 // test the function
 integer result;
 integer n;
 initial begin
    for(n = 0; n <= 7; n = n+1) begin
        result = factorial_auto(n);
        $display("%0d factorial_auto=%0d", n, result);
        result = factorial(n);
        $display("%0d factorial=%0d", n, result);
    end
  end
endmodule
