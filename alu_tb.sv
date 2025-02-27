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

        // Basic SUB
        a = 32'd2032; b = 32'd32; sel = `SUB;
        $display("a=%d, b=%d, a-b=%d", a, b, out); //32'2000
        assert(out == 32'd2000)
            $display("PASS: Basic SUB");
        else
            $display("FAIL: Basic SUB");

        // ------------------------------------ADD----------------------------------------------
        // Basic ADD
        a = 32'd10; b = 32'd5; sel = `ADD;              // a = d2,147,647, b = d1, sel = ADD
        #10 $display("a=%d, b=%d, a+b=%d", a, b, out);  // out = d15
        assert (out == 32'd15)
            $display("PASS: Basic ADD");
        else
            $display("FAIL: Basic ADD");

        // Zero ADD
        a = 32'd0; b = 32'd0; sel = `ADD;               // a = d2,147,647, b = d1, sel = ADD
        #10 $display("a=%d, b=%d, a+b=%d", a, b, out);  // out = d0
        assert (out == 32'd0)
            $display("PASS: Zero ADD");
        else
            $display("FAIL: Zero ADD");

        // Overflow (Postive) ADD
        a = 32'h7FFFFFFF; b = 32'h1; sel = `ADD;        // a = d2,147,647, b = d1, sel = ADD
        #10 $display("a=%d, b=%d, a+b=%d", a, b, out);  // out = -d2,147,483,648
        assert (out == 32'h80000000)
            $display("PASS: Overflow (Postive) ADD");
        else
            $display("FAIL: Overflow (Postive) ADD");

        // Overflow (Negative) ADD
        a = 32'h80000000; b = -32'h1; sel = `ADD;                                  // a = -d2,147,648, b = -d1, sel = ADD
        #10 $display("a=%d, b=%d, a+b=%d", $signed(a), $signed(b), $signed(out)); // out = d2,147,483,647
        assert (out == 32'h7FFFFFFF)
            $display("PASS: Overflow (Negative) ADD");
        else
            $display("FAIL: Overflow (Negative) ADD");
        // -------------------------------------------------------------------------------------

        // ------------------------------------SUB----------------------------------------------
        // Basic SUB
        a = 32'd2032; b = 32'd32; sel = `SUB;
        $display("a=%d, b=%d, a-b=%d", a, b, out); //32'2000
        assert(out == 32'd2000)
            $display("PASS: Basic SUB");
        else
            $display("FAIL: Basic SUB");



        $finish;
    end
endmodule
