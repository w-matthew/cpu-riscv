`include "alu_op.vh"

module alu_tb;
    // these change, hence the need for reg
    reg  [31:0] a;
    reg  [31:0] b;
    reg  [3:0] sel;
    // this changes based on the combinatorial alu, hence wire
    wire [31:0] out;

    alu DUT (
        .a  (a),
        .b  (b),
        .sel(sel),
        .out(out)
    );

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
        // Basic ADD
        a = 32'd2000; b = 32'd32; sel = `ADD;
        #10 $display("a=%d, b=%d, a+b=%d", a, b, out);  // 32'd2032

        #10 $finish;
    end
endmodule
