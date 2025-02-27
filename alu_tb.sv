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

    // Variables to tally passes/fails
    integer add_pass = 0, add_fail = 0;
    integer sub_pass = 0, sub_fail = 0;
    integer xor_pass = 0, xor_fail = 0;
    integer or_pass = 0, or_fail = 0;
    integer and_pass = 0, and_fail = 0;
    integer sll_pass = 0, sll_fail = 0;

    integer total_pass = 0, total_fail = 0;

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

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
        #10 $display("a=%d, b=%d, a-b=%d", a, b, out); //32'2000
        assert(out == 32'd2000)
            $display("PASS: Basic SUB");
        else
            $display("FAIL: Basic SUB");

        // Zero SUB
        a = 32'd0; b = 32'd0; sel = `SUB;
        #10 $display("a=%d, b=%d, a-b=%d", a, b, out);
        assert(out == 32'd0)
            $display("PASS: Zero SUB");
        else
            $display("FAIL: Zero SUB");

        // Overflow (Postive) SUB
        a = 32'h80000000; b = 32'h1; sel = `SUB;        // a = -d2,147,648, b = d1, sel = ADD
        #10 $display("a=%d, b=%d, a-b=%d", $signed(a), $signed(b), $signed(out));  // out = d2,147,483,647
        assert (out == 32'h7FFFFFFF)
            $display("PASS: Overflow (Postive) SUB");
        else
            $display("FAIL: Overflow (Positive) SUB");

        // Overflow (Negative) SUB
        a = 32'h7FFFFFFF; b = -32'h1; sel = `SUB;                                  // a = d2,147,483,647, b = -d1, sel = ADD
        #10 $display("a=%d, b=%d, a-b=%d", $signed(a), $signed(b), $signed(out)); // out = -d2,147,483,648
        assert (out == 32'h80000000)
            $display("PASS: Overflow (Negative) SUB");
        else
            $display("FAIL: Overflow (Negative) SUB");



        // -------------------------------------------------------------------------------------

        // ------------------------------------XOR----------------------------------------------

        // Basic XOR (0, 0)
        a = 32'b0; b = 32'b0; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        assert(out == 32'b0)
            $display("PASS: (0, 0) XOR");
        else
            $display("FAIL: (0, 0) XOR");

        // Basic XOR (0, 1)
        a = 32'b0; b = 32'b1; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        assert(out == 32'b1)
            $display("PASS: (0, 1) XOR");
        else
            $display("FAIL: (0, 1) XOR");

        // Basic XOR (1, 0)
        a = 32'b1; b = 32'b0; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        assert(out == 32'b1)
            $display("PASS: (1, 0) XOR");
        else
            $display("FAIL: (1, 0) XOR");

        // Basic XOR (1, 1)
        a = 32'b1; b = 32'b1; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        assert(out == 32'b0)
            $display("PASS: (1, 1) XOR");
        else
            $display("FAIL: (1, 1) XOR");

        // All 0's and all 1's
        a = 32'h0; b = 32'hFFFFFFFF; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        assert(out == 32'hFFFFFFFF)
            $display("PASS: All 0's and all 1's XOR");
        else
            $display("FAIL: All 0's and all 1's XOR");

        // Mixed bit pattern
        a = 32'hAAAAAAAA; b = 32'h55555555; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        assert(out == 32'hFFFFFFFF)
            $display("PASS: Mixed bit pattern XOR");
        else
            $display("FAIL: Mixed bit pattern XOR");

        // Identity property
        a = 32'hA5A5A5A5; b = 32'h00000000; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        assert(out == 32'hA5A5A5A5)
            $display("PASS: Identity property XOR");
        else
            $display("FAIL: Identity property XOR");

        // Complement property
        a = 32'hA5A5A5A5; b = 32'hFFFFFFFF; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        assert(out == 32'h5A5A5A5A)
            $display("PASS: Complement property XOR");
        else
            $display("FAIL: Complement property XOR");

        // -------------------------------------------------------------------------------------

        // ------------------------------------OR-----------------------------------------------

        // Basic OR (0, 0)
        a = 32'b0; b = 32'b0; sel = `OR;
        #10 $display("a=%b, b=%b, a|b=%b", a, b, out);
        assert(out == 32'b0)
            $display("PASS: (0, 0) OR");
        else
            $display("FAIL: (0, 0) OR");

        // Basic OR (0, 1)
        a = 32'b0; b = 32'b1; sel = `OR;
        #10 $display("a=%b, b=%b, a|b=%b", a, b, out);
        assert(out == 32'b1)
            $display("PASS: (0, 1) OR");
        else
            $display("FAIL: (0, 1) OR");

        // Basic OR (1, 0)
        a = 32'b1; b = 32'b0; sel = `OR;
        #10 $display("a=%b, b=%b, a|b=%b", a, b, out);
        assert(out == 32'b1)
            $display("PASS: (1, 0) OR");
        else
            $display("FAIL: (1, 0) OR");

        // Basic OR (1, 1)
        a = 32'b1; b = 32'b1; sel = `OR;
        #10 $display("a=%b, b=%b, a|b=%b", a, b, out);
        assert(out == 32'b1)
            $display("PASS: (1, 1) OR");
        else
            $display("FAIL: (1, 1) OR");

        // All 0's and all 1's
        a = 32'h0; b = 32'hFFFFFFFF; sel = `OR;
        #10 $display("a=%h, b=%h, a|b=%h", a, b, out);
        assert(out == 32'hFFFFFFFF)
            $display("PASS: All 0's and all 1's OR");
        else
            $display("FAIL: All 0's and all 1's OR");

        // Mixed bit pattern
        a = 32'hAAAAAAAA; b = 32'h55555555; sel = `OR;
        #10 $display("a=%h, b=%h, a|b=%h", a, b, out);
        assert(out == 32'hFFFFFFFF)
            $display("PASS: Mixed bit pattern OR");
        else
            $display("FAIL: Mixed bit pattern OR");

        // Identity property (OR with 0)
        a = 32'hA5A5A5A5; b = 32'h00000000; sel = `OR;
        #10 $display("a=%h, b=%h, a|b=%h", a, b, out);
        assert(out == 32'hA5A5A5A5)
            $display("PASS: Identity property OR");
        else
            $display("FAIL: Identity property OR");

        // Domination property (OR with all 1's)
        a = 32'hA5A5A5A5; b = 32'hFFFFFFFF; sel = `OR;
        #10 $display("a=%h, b=%h, a|b=%h", a, b, out);
        assert(out == 32'hFFFFFFFF)
            $display("PASS: Domination property OR");
        else
            $display("FAIL: Domination property OR");

        // -------------------------------------------------------------------------------------

        // ------------------------------------AND----------------------------------------------
        // Basic AND (0, 0)
        a = 32'b0; b = 32'b0; sel = `AND;
        #10 $display("a=%b, b=%b, a&b=%b", a, b, out);
        assert(out == 32'b0)
            $display("PASS: (0, 0) AND");
        else
            $display("FAIL: (0, 0) AND");

        // Basic AND (0, 1)
        a = 32'b0; b = 32'b1; sel = `AND;
        #10 $display("a=%b, b=%b, a&b=%b", a, b, out);
        assert(out == 32'b0)
            $display("PASS: (0, 1) AND");
        else
            $display("FAIL: (0, 1) AND");

        // Basic AND (1, 0)
        a = 32'b1; b = 32'b0; sel = `AND;
        #10 $display("a=%b, b=%b, a&b=%b", a, b, out);
        assert(out == 32'b0)
            $display("PASS: (1, 0) AND");
        else
            $display("FAIL: (1, 0) AND");

        // Basic AND (1, 1)
        a = 32'b1; b = 32'b1; sel = `AND;
        #10 $display("a=%b, b=%b, a&b=%b", a, b, out);
        assert(out == 32'b1)
            $display("PASS: (1, 1) AND");
        else
            $display("FAIL: (1, 1) AND");

        // All 1's and all 1's
        a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; sel = `AND;
        #10 $display("a=%h, b=%h, a&b=%h", a, b, out);
        assert(out == 32'hFFFFFFFF)
            $display("PASS: All 1's and all 1's AND");
        else
            $display("FAIL: All 1's and all 1's AND");

        // Mixed bit pattern
        a = 32'hAAAAAAAA; b = 32'h55555555; sel = `AND;
        #10 $display("a=%h, b=%h, a&b=%h", a, b, out);
        assert(out == 32'h0)
            $display("PASS: Mixed bit pattern AND");
        else
            $display("FAIL: Mixed bit pattern AND");

        // Domination property (AND with 0)
        a = 32'hA5A5A5A5; b = 32'h00000000; sel = `AND;
        #10 $display("a=%h, b=%h, a&b=%h", a, b, out);
        assert(out == 32'h0)
            $display("PASS: Domination property AND");
        else
            $display("FAIL: Domination property AND");

        // Identity property (AND with all 1's)
        a = 32'hA5A5A5A5; b = 32'hFFFFFFFF; sel = `AND;
        #10 $display("a=%h, b=%h, a&b=%h", a, b, out);
        assert(out == 32'hA5A5A5A5)
            $display("PASS: Identity property AND");
        else
            $display("FAIL: Identity property AND");

// --------------------------------------------------------------------------------------------------

// ------------------------------------SLL-----------------------------------------------------------
// Like multiplication (2^1, 2^2, 2^3, ...)

        // Basic shift by 1
        a = 32'h1; b = 32'd1; sel = `SLL;
        #10 $display("a=%h, b=%d, a<<b=%h", a, b, out);
        if (out == 32'h2) begin
            $display("PASS: Shift left by 1");
            sll_pass++;
        end else begin
            $display("FAIL: Shift left by 1");
            sll_fail++;
        end

        // Shift multiple positions
        a = 32'h1; b = 32'd4; sel = `SLL;
        #10 $display("a=%h, b=%d, a<<b=%h", a, b, out);
        if (out == 32'h10) begin
            $display("PASS: Shift left by 4");
            sll_pass++;
        end else begin
            $display("FAIL: Shift left by 4");
            sll_fail++;
        end

        // Test with multiple bits set
        a = 32'h0F0F; b = 32'd8; sel = `SLL;
        #10 $display("a=%h, b=%d, a<<b=%h", a, b, out);
        if (out == 32'h0F0F00) begin
            $display("PASS: Multiple bits shift");
            sll_pass++;
        end else begin
            $display("FAIL: Multiple bits shift");
            sll_fail++;
        end

        // Shift by 0 (no change)
        a = 32'hA5A5A5A5; b = 32'd0; sel = `SLL;
        #10 $display("a=%h, b=%d, a<<b=%h", a, b, out);
        if (out == 32'hA5A5A5A5) begin
            $display("PASS: Shift left by 0");
            sll_pass++;
        end else begin
            $display("FAIL: Shift left by 0");
            sll_fail++;
        end

        // Shift that causes bits to be lost (overflow)
        a = 32'h80000001; b = 32'd1; sel = `SLL;
        #10 $display("a=%h, b=%d, a<<b=%h", a, b, out);
        if (out == 32'h00000002) begin
            $display("PASS: Shift with overflow");
            sll_pass++;
        end else begin
            $display("FAIL: Shift with overflow");
            sll_fail++;
        end

        // Maximum shift (31 bits)
        a = 32'h1; b = 32'd31; sel = `SLL;
        #10 $display("a=%h, b=%d, a<<b=%h", a, b, out);
        if (out == 32'h80000000) begin
            $display("PASS: Maximum shift (31 bits)");
            sll_pass++;
        end else begin
            $display("FAIL: Maximum shift (31 bits)");
            sll_fail++;
        end

        // Shift beyond word size (only lower 5 bits of b should be used)
        a = 32'h1; b = 32'd32; sel = `SLL;
        #10 $display("a=%h, b=%d, a<<b=%h", a, b, out);
        if (out == 32'h1) begin  // 32 % 32 = 0, so shift by 0
            $display("PASS: Shift beyond word size");
            sll_pass++;
        end else begin
            $display("FAIL: Shift beyond word size");
            sll_fail++;
        end

        // Shift by large value (only lower 5 bits matter)
        a = 32'h1; b = 32'd36; sel = `SLL;
        #10 $display("a=%h, b=%d, a<<b=%h", a, b, out);
        if (out == 32'h10) begin  // 36 % 32 = 4, so shift by 4
            $display("PASS: Shift by value > 32");
            sll_pass++;
        end else begin
            $display("FAIL: Shift by value > 32");
            sll_fail++;
        end

        $display("\n----- TEST SUMMARY -----");
        $display("SLL: %d passed, %d failed", sll_pass, sll_fail);

        $finish;
    end
endmodule
