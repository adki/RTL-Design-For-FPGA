module top;
    reg       a;
    reg [1:0] b;
    reg [3:0] c;
    reg [6:0] d;
    reg [9:0] e;
    initial begin
        a = 1'b1;
        b = 2'b01;
        c = {4{a}};
        d = {3{b}};
        e = {b, c, b};
        $display("a=%b b=%b c=%b d=%b e=%b", a, b, c, d, e);
    end
endmodule
