// full_adder_ref.v
`timescale 1 ns/1 ps

module full_adder_ref(sum,cout,in1,in2,cin,clk,resetb);
    output sum, cout;
    input  in1, in2, cin;
    input  clk, resetb;

    wire   sum, cout;
    reg    rin1, rin2, rcin;
    wire   s1, c1;
    wire   s2, c2;

    always @ (posedge clk or negedge resetb) begin
         if (resetb==1'b0) begin
            rin1 <= 1'b0;
            rin2 <= 1'b0;
            rcin <= 1'b0;
         end else begin
            rin1 <= in1;
            rin2 <= in2;
            rcin <= cin;
         end
    end
    
    assign {cout, sum} = rin1+rin2+rcin;

endmodule
