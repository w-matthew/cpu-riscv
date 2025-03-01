`include "alu_sel.vh"

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
    integer srl_pass = 0, srl_fail = 0;
    integer sra_pass = 0, sra_fail = 0;
    integer slt_pass = 0, slt_fail = 0;
    integer sltu_pass = 0, sltu_fail = 0;

    integer total_pass = 0, total_fail = 0;

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

// ------------------------------------ADD----------------------------------------------
        // Basic ADD
        a = 32'd10; b = 32'd5; sel = `ADD;              // a = d2,147,647, b = d1, sel = ADD
        #10 $display("a=%d, b=%d, a+b=%d", a, b, out);  // out = d15
        if (out == 32'd15) begin
            $display("PASS: Basic ADD");
            add_pass++;
        end else begin
            $display("FAIL: Basic ADD");
            add_fail++;
        end

        // Zero ADD
        a = 32'd0; b = 32'd0; sel = `ADD;               // a = d2,147,647, b = d1, sel = ADD
        #10 $display("a=%d, b=%d, a+b=%d", a, b, out);  // out = d0
        if (out == 32'd0) begin
            $display("PASS: Zero ADD");
            add_pass++;
        end else begin
            $display("FAIL: Zero ADD");
            add_fail++;
        end

        // Overflow (Postive) ADD
        a = 32'h7FFFFFFF; b = 32'h1; sel = `ADD;        // a = d2,147,647, b = d1, sel = ADD
        #10 $display("a=%d, b=%d, a+b=%d", a, b, out);  // out = -d2,147,483,648
        if (out == 32'h80000000) begin
            $display("PASS: Overflow (Postive) ADD");
            add_pass++;
        end else begin
            $display("FAIL: Overflow (Postive) ADD");
            add_fail++;
        end

        // Overflow (Negative) ADD
        a = 32'h80000000; b = -32'h1; sel = `ADD;                                  // a = -d2,147,648, b = -d1, sel = ADD
        #10 $display("a=%d, b=%d, a+b=%d", $signed(a), $signed(b), $signed(out)); // out = d2,147,483,647
        if (out == 32'h7FFFFFFF) begin
            $display("PASS: Overflow (Negative) ADD");
            add_pass++;
        end else begin
            $display("FAIL: Overflow (Negative) ADD");
            add_fail++;
        end
// -------------------------------------------------------------------------------------

// ------------------------------------SUB----------------------------------------------
        // Basic SUB
        a = 32'd2032; b = 32'd32; sel = `SUB;
        #10 $display("a=%d, b=%d, a-b=%d", a, b, out); //32'2000
        if (out == 32'd2000) begin
            $display("PASS: Basic SUB");
            sub_pass++;
        end else begin
            $display("FAIL: Basic SUB");
            sub_fail++;
        end

        // Zero SUB
        a = 32'd0; b = 32'd0; sel = `SUB;
        #10 $display("a=%d, b=%d, a-b=%d", a, b, out);
        if (out == 32'd0) begin
            $display("PASS: Zero SUB");
            sub_pass++;
        end else begin
            $display("FAIL: Zero SUB");
            sub_fail++;
        end

        // Overflow (Postive) SUB
        a = 32'h80000000; b = 32'h1; sel = `SUB;        // a = -d2,147,648, b = d1, sel = ADD
        #10 $display("a=%d, b=%d, a-b=%d", $signed(a), $signed(b), $signed(out));  // out = d2,147,483,647
        if (out == 32'h7FFFFFFF) begin
            $display("PASS: Overflow (Postive) SUB");
            sub_pass++;
        end else begin
            $display("FAIL: Overflow (Positive) SUB");
            sub_fail++;
        end

        // Overflow (Negative) SUB
        a = 32'h7FFFFFFF; b = -32'h1; sel = `SUB;                                  // a = d2,147,483,647, b = -d1, sel = ADD
        #10 $display("a=%d, b=%d, a-b=%d", $signed(a), $signed(b), $signed(out)); // out = -d2,147,483,648
        if (out == 32'h80000000) begin
            $display("PASS: Overflow (Negative) SUB");
            sub_pass++;
        end else begin
            $display("FAIL: Overflow (Negative) SUB");
            sub_fail++;
        end
// -------------------------------------------------------------------------------------

// ------------------------------------XOR----------------------------------------------
        // Basic XOR (0, 0)
        a = 32'b0; b = 32'b0; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        if (out == 32'b0) begin
            $display("PASS: (0, 0) XOR");
            xor_pass++;
        end else begin
            $display("FAIL: (0, 0) XOR");
            xor_fail++;
        end

        // Basic XOR (0, 1)
        a = 32'b0; b = 32'b1; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        if (out == 32'b1) begin
            $display("PASS: (0, 1) XOR");
            xor_pass++;
        end else begin
            $display("FAIL: (0, 1) XOR");
            xor_fail++;
        end

        // Basic XOR (1, 0)
        a = 32'b1; b = 32'b0; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        if (out == 32'b1) begin
            $display("PASS: (1, 0) XOR");
            xor_pass++;
        end else begin
            $display("FAIL: (1, 0) XOR");
            xor_fail++;
        end

        // Basic XOR (1, 1)
        a = 32'b1; b = 32'b1; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        if (out == 32'b0) begin
            $display("PASS: (1, 1) XOR");
            xor_pass++;
        end else begin
            $display("FAIL: (1, 1) XOR");
            xor_fail++;
        end

        // All 0's and all 1's
        a = 32'h0; b = 32'hFFFFFFFF; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        if (out == 32'hFFFFFFFF) begin
            $display("PASS: All 0's and all 1's XOR");
            xor_pass++;
        end else begin
            $display("FAIL: All 0's and all 1's XOR");
            xor_fail++;
        end

        // Mixed bit pattern
        a = 32'hAAAAAAAA; b = 32'h55555555; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        if (out == 32'hFFFFFFFF) begin
            $display("PASS: Mixed bit pattern XOR");
            xor_pass++;
        end else begin
            $display("FAIL: Mixed bit pattern XOR");
            xor_fail++;
        end

        // Identity property
        a = 32'hA5A5A5A5; b = 32'h00000000; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        if (out == 32'hA5A5A5A5) begin
            $display("PASS: Identity property XOR");
            xor_pass++;
        end else begin
            $display("FAIL: Identity property XOR");
            xor_fail++;
        end

        // Complement property
        a = 32'hA5A5A5A5; b = 32'hFFFFFFFF; sel = `XOR;
        #10 $display("a=%b, b=%b, a^b=%b", a, b, out);
        if (out == 32'h5A5A5A5A) begin
            $display("PASS: Complement property XOR");
            xor_pass++;
        end else begin
            $display("FAIL: Complement property XOR");
            xor_fail++;
        end
// -------------------------------------------------------------------------------------

// ------------------------------------OR-----------------------------------------------
        // Basic OR (0, 0)
        a = 32'b0; b = 32'b0; sel = `OR;
        #10 $display("a=%b, b=%b, a|b=%b", a, b, out);
        if (out == 32'b0) begin
            $display("PASS: (0, 0) OR");
            or_pass++;
        end else begin
            $display("FAIL: (0, 0) OR");
            or_fail++;
        end

        // Basic OR (0, 1)
        a = 32'b0; b = 32'b1; sel = `OR;
        #10 $display("a=%b, b=%b, a|b=%b", a, b, out);
        if (out == 32'b1) begin
            $display("PASS: (0, 1) OR");
            or_pass++;
        end else begin
            $display("FAIL: (0, 1) OR");
            or_fail++;
        end

        // Basic OR (1, 0)
        a = 32'b1; b = 32'b0; sel = `OR;
        #10 $display("a=%b, b=%b, a|b=%b", a, b, out);
        if (out == 32'b1) begin
            $display("PASS: (1, 0) OR");
            or_pass++;
        end else begin
            $display("FAIL: (1, 0) OR");
            or_fail++;
        end

        // Basic OR (1, 1)
        a = 32'b1; b = 32'b1; sel = `OR;
        #10 $display("a=%b, b=%b, a|b=%b", a, b, out);
        if (out == 32'b1) begin
            $display("PASS: (1, 1) OR");
            or_pass++;
        end else begin
            $display("FAIL: (1, 1) OR");
            or_fail++;
        end

        // All 0's and all 1's
        a = 32'h0; b = 32'hFFFFFFFF; sel = `OR;
        #10 $display("a=%h, b=%h, a|b=%h", a, b, out);
        if (out == 32'hFFFFFFFF) begin
            $display("PASS: All 0's and all 1's OR");
            or_pass++;
        end else begin
            $display("FAIL: All 0's and all 1's OR");
            or_fail++;
        end

        // Mixed bit pattern
        a = 32'hAAAAAAAA; b = 32'h55555555; sel = `OR;
        #10 $display("a=%h, b=%h, a|b=%h", a, b, out);
        if (out == 32'hFFFFFFFF) begin
            $display("PASS: Mixed bit pattern OR");
            or_pass++;
        end else begin
            $display("FAIL: Mixed bit pattern OR");
            or_fail++;
        end

        // Identity property (OR with 0)
        a = 32'hA5A5A5A5; b = 32'h00000000; sel = `OR;
        #10 $display("a=%h, b=%h, a|b=%h", a, b, out);
        if (out == 32'hA5A5A5A5) begin
            $display("PASS: Identity property OR");
            or_pass++;
        end else begin
            $display("FAIL: Identity property OR");
            or_fail++;
        end

        // Domination property (OR with all 1's)
        a = 32'hA5A5A5A5; b = 32'hFFFFFFFF; sel = `OR;
        #10 $display("a=%h, b=%h, a|b=%h", a, b, out);
        if (out == 32'hFFFFFFFF) begin
            $display("PASS: Domination property OR");
            or_pass++;
        end else begin
            $display("FAIL: Domination property OR");
            or_fail++;
        end
// -------------------------------------------------------------------------------------

// ------------------------------------AND----------------------------------------------
        // Basic AND (0, 0)
        a = 32'b0; b = 32'b0; sel = `AND;
        #10 $display("a=%b, b=%b, a&b=%b", a, b, out);
        if (out == 32'b0) begin
            $display("PASS: (0, 0) AND");
            and_pass++;
        end else begin
            $display("FAIL: (0, 0) AND");
            and_fail++;
        end

        // Basic AND (0, 1)
        a = 32'b0; b = 32'b1; sel = `AND;
        #10 $display("a=%b, b=%b, a&b=%b", a, b, out);
        if (out == 32'b0) begin
            $display("PASS: (0, 1) AND");
            and_pass++;
        end else begin
            $display("FAIL: (0, 1) AND");
            and_fail++;
        end

        // Basic AND (1, 0)
        a = 32'b1; b = 32'b0; sel = `AND;
        #10 $display("a=%b, b=%b, a&b=%b", a, b, out);
        if (out == 32'b0) begin
            $display("PASS: (1, 0) AND");
            and_pass++;
        end else begin
            $display("FAIL: (1, 0) AND");
            and_fail++;
        end

        // Basic AND (1, 1)
        a = 32'b1; b = 32'b1; sel = `AND;
        #10 $display("a=%b, b=%b, a&b=%b", a, b, out);
        if (out == 32'b1) begin
            $display("PASS: (1, 1) AND");
            and_pass++;
        end else begin
            $display("FAIL: (1, 1) AND");
            and_fail++;
        end

        // All 1's and all 1's
        a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; sel = `AND;
        #10 $display("a=%h, b=%h, a&b=%h", a, b, out);
        if (out == 32'hFFFFFFFF) begin
            $display("PASS: All 1's and all 1's AND");
            and_pass++;
        end else begin
            $display("FAIL: All 1's and all 1's AND");
            and_fail++;
        end

        // Mixed bit pattern
        a = 32'hAAAAAAAA; b = 32'h55555555; sel = `AND;
        #10 $display("a=%h, b=%h, a&b=%h", a, b, out);
        if (out == 32'h0) begin
            $display("PASS: Mixed bit pattern AND");
            and_pass++;
        end else begin
            $display("FAIL: Mixed bit pattern AND");
            and_fail++;
        end

        // Domination property (AND with 0)
        a = 32'hA5A5A5A5; b = 32'h00000000; sel = `AND;
        #10 $display("a=%h, b=%h, a&b=%h", a, b, out);
        if (out == 32'h0) begin
            $display("PASS: Domination property AND");
            and_pass++;
        end else begin
            $display("FAIL: Domination property AND");
            and_fail++;
        end

        // Identity property (AND with all 1's)
        a = 32'hA5A5A5A5; b = 32'hFFFFFFFF; sel = `AND;
        #10 $display("a=%h, b=%h, a&b=%h", a, b, out);
        if (out == 32'hA5A5A5A5) begin
            $display("PASS: Identity property AND");
            and_pass++;
        end else begin
            $display("FAIL: Identity property AND");
            and_fail++;
        end
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
// --------------------------------------------------------------------------------------------------

// ------------------------------------SRL-----------------------------------------------------------
// Shift Right Logical - shifts bits right, filling with zeros

        // Basic shift by 1
        a = 32'h10; b = 32'd1; sel = `SRL;
        #10 $display("a=%h, b=%d, a>>b=%h", a, b, out);
        if (out == 32'h8) begin
            $display("PASS: SRL by 1");
            srl_pass++;
        end else begin
            $display("FAIL: SRL by 1");
            srl_fail++;
        end

        // Shift multiple positions
        a = 32'h10; b = 32'd4; sel = `SRL;
        #10 $display("a=%h, b=%d, a>>b=%h", a, b, out);
        if (out == 32'h1) begin
            $display("PASS: SRL by 4");
            srl_pass++;
        end else begin
            $display("FAIL: SRL by 4");
            srl_fail++;
        end

        // Test with high bit set (should not be sign-extended)
        a = 32'h80000000; b = 32'd4; sel = `SRL;
        #10 $display("a=%h, b=%d, a>>b=%h", a, b, out);
        if (out == 32'h08000000) begin
            $display("PASS: SRL high bit");
            srl_pass++;
        end else begin
            $display("FAIL: SRL high bit");
            srl_fail++;
        end

        // Shift by 0 (no change)
        a = 32'hA5A5A5A5; b = 32'd0; sel = `SRL;
        #10 $display("a=%h, b=%d, a>>b=%h", a, b, out);
        if (out == 32'hA5A5A5A5) begin
            $display("PASS: SRL by 0");
            srl_pass++;
        end else begin
            $display("FAIL: SRL by 0");
            srl_fail++;
        end

        // Maximum shift (31 bits)
        a = 32'h80000000; b = 32'd31; sel = `SRL;
        #10 $display("a=%h, b=%d, a>>b=%h", a, b, out);
        if (out == 32'h1) begin
            $display("PASS: SRL maximum (31 bits)");
            srl_pass++;
        end else begin
            $display("FAIL: SRL maximum (31 bits)");
            srl_fail++;
        end

        // Shift beyond word size (only lower 5 bits used)
        a = 32'h12345678; b = 32'd36; sel = `SRL;
        #10 $display("a=%h, b=%d, a>>b=%h", a, b, out);
        if (out == 32'h01234567) begin  // 36 % 32 = 4, so shift by 4
            $display("PASS: SRL with b > 32");
            srl_pass++;
        end else begin
            $display("FAIL: SRL with b > 32");
            srl_fail++;
        end
// --------------------------------------------------------------------------------------------------

// ------------------------------------SRA-----------------------------------------------------------
// Shift Right Arithmetic - like division, but sign bit is preserved

        // Basic shift right by 1 (positive number)
        a = 32'h10; b = 32'd1; sel = `SRA;
        #10 $display("a=%h, b=%d, a>>>b=%h", a, b, out);
        if (out == 32'h8) begin
            $display("PASS: SRA positive by 1");
            sra_pass++;
        end else begin
            $display("FAIL: SRA positive by 1");
            sra_fail++;
        end

        // Basic shift right by 1 (negative number)
        a = 32'h80000010; b = 32'd1; sel = `SRA;
        #10 $display("a=%h, b=%d, a>>>b=%h", a, b, out);
        if (out == 32'hC0000008) begin
            $display("PASS: SRA negative by 1");
            sra_pass++;
        end else begin
            $display("FAIL: SRA negative by 1");
            sra_fail++;
        end

        // Shift multiple positions (positive)
        a = 32'h10; b = 32'd4; sel = `SRA;
        #10 $display("a=%h, b=%d, a>>>b=%h", a, b, out);
        if (out == 32'h1) begin
            $display("PASS: SRA positive by 4");
            sra_pass++;
        end else begin
            $display("FAIL: SRA positive by 4");
            sra_fail++;
        end

        // Shift multiple positions (negative)
        a = 32'h80000100; b = 32'd8; sel = `SRA;
        #10 $display("a=%h, b=%d, a>>>b=%h", a, b, out);
        if (out == 32'hFF800001) begin
            $display("PASS: SRA negative by 8");
            sra_pass++;
        end else begin
            $display("FAIL: SRA negative by 8");
            sra_fail++;
        end

        // Shift by 0 (no change)
        a = 32'hA5A5A5A5; b = 32'd0; sel = `SRA;
        #10 $display("a=%h, b=%d, a>>>b=%h", a, b, out);
        if (out == 32'hA5A5A5A5) begin
            $display("PASS: SRA by 0");
            sra_pass++;
        end else begin
            $display("FAIL: SRA by 0");
            sra_fail++;
        end

        // Shift all bits except sign bit (positive)
        a = 32'h7FFFFFFF; b = 32'd31; sel = `SRA;
        #10 $display("a=%h, b=%d, a>>>b=%h", a, b, out);
        if (out == 32'h0) begin
            $display("PASS: SRA positive all bits");
            sra_pass++;
        end else begin
            $display("FAIL: SRA positive all bits");
            sra_fail++;
        end

        // Shift all bits except sign bit (negative)
        a = 32'h80000001; b = 32'd31; sel = `SRA;
        #10 $display("a=%h, b=%d, a>>>b=%h", a, b, out);
        if (out == 32'hFFFFFFFF) begin
            $display("PASS: SRA negative all bits");
            sra_pass++;
        end else begin
            $display("FAIL: SRA negative all bits");
            sra_fail++;
        end

        // Shift beyond word size (only lower 5 bits of b should be used)
        a = 32'h12345678; b = 32'd32; sel = `SRA;
        #10 $display("a=%h, b=%d, a>>>b=%h", a, b, out);
        if (out == 32'h12345678) begin  // 32 % 32 = 0, so shift by 0
            $display("PASS: SRA beyond word size");
            sra_pass++;
        end else begin
            $display("FAIL: SRA beyond word size");
            sra_fail++;
        end

        // Shift by large value (only lower 5 bits matter)
        a = 32'h12345678; b = 32'd36; sel = `SRA;
        #10 $display("a=%h, b=%d, a>>>b=%h", a, b, out);
        if (out == 32'h01234567) begin  // 36 % 32 = 4, so shift by 4
            $display("PASS: SRA by value > 32");
            sra_pass++;
        end else begin
            $display("FAIL: SRA by value > 32");
            sra_fail++;
        end

        // Negative max value (verify sign extension)
        a = 32'h80000000; b = 32'd16; sel = `SRA;
        #10 $display("a=%h, b=%d, a>>>b=%h", a, b, out);
        if (out == 32'hFFFF8000) begin
            $display("PASS: SRA negative max value");
            sra_pass++;
        end else begin
            $display("FAIL: SRA negative max value");
            sra_fail++;
        end
// --------------------------------------------------------------------------------------------------

// ------------------------------------SLT-----------------------------------------------------------
// Set Less Than - compares signed values, returns 1 if a < b, 0 otherwise

        // Basic comparison (less than)
        a = 32'd5; b = 32'd10; sel = `SLT;
        #10 $display("a=%d, b=%d, a<b=%d", $signed(a), $signed(b), out);
        if (out == 32'd1) begin
            $display("PASS: SLT basic less than");
            slt_pass++;
        end else begin
            $display("FAIL: SLT basic less than");
            slt_fail++;
        end

        // Basic comparison (greater than)
        a = 32'd15; b = 32'd10; sel = `SLT;
        #10 $display("a=%d, b=%d, a<b=%d", $signed(a), $signed(b), out);
        if (out == 32'd0) begin
            $display("PASS: SLT basic greater than");
            slt_pass++;
        end else begin
            $display("FAIL: SLT basic greater than");
            slt_fail++;
        end

        // Equal values
        a = 32'd10; b = 32'd10; sel = `SLT;
        #10 $display("a=%d, b=%d, a<b=%d", $signed(a), $signed(b), out);
        if (out == 32'd0) begin
            $display("PASS: SLT equal values");
            slt_pass++;
        end else begin
            $display("FAIL: SLT equal values");
            slt_fail++;
        end

        // Signed comparison (negative < positive)
        a = -32'd5; b = 32'd10; sel = `SLT;
        #10 $display("a=%d, b=%d, a<b=%d", $signed(a), $signed(b), out);
        if (out == 32'd1) begin
            $display("PASS: SLT negative < positive");
            slt_pass++;
        end else begin
            $display("FAIL: SLT negative < positive");
            slt_fail++;
        end

        // Signed comparison (both negative)
        a = -32'd15; b = -32'd5; sel = `SLT;
        #10 $display("a=%d, b=%d, a<b=%d", $signed(a), $signed(b), out);
        if (out == 32'd1) begin
            $display("PASS: SLT both negative");
            slt_pass++;
        end else begin
            $display("FAIL: SLT both negative");
            slt_fail++;
        end
// ---------------------------------------------------------------------------------------------------

// ------------------------------------SLTU-----------------------------------------------------------
// Set Less Than Unsigned - compares unsigned values, returns 1 if a < b, 0 otherwise

        // Basic comparison (less than)
        a = 32'd5; b = 32'd10; sel = `SLTU;
        #10 $display("a=%d, b=%d, a<b=%d (unsigned)", a, b, out);
        if (out == 32'd1) begin
            $display("PASS: SLTU basic less than");
            sltu_pass++;
        end else begin
            $display("FAIL: SLTU basic less than");
            sltu_fail++;
        end

        // Basic comparison (greater than)
        a = 32'd15; b = 32'd10; sel = `SLTU;
        #10 $display("a=%d, b=%d, a<b=%d (unsigned)", a, b, out);
        if (out == 32'd0) begin
            $display("PASS: SLTU basic greater than");
            sltu_pass++;
        end else begin
            $display("FAIL: SLTU basic greater than");
            sltu_fail++;
        end

        // Equal values
        a = 32'd10; b = 32'd10; sel = `SLTU;
        #10 $display("a=%d, b=%d, a<b=%d (unsigned)", a, b, out);
        if (out == 32'd0) begin
            $display("PASS: SLTU equal values");
            sltu_pass++;
        end else begin
            $display("FAIL: SLTU equal values");
            sltu_fail++;
        end

        // Key test: Negative value treated as large unsigned
        a = 32'hFFFFFFFF; b = 32'd10; sel = `SLTU;
        #10 $display("a=%h (%d signed), b=%d, a<b=%d (unsigned)", a, $signed(a), b, out);
        if (out == 32'd0) begin
            $display("PASS: SLTU negative as unsigned");
            sltu_pass++;
        end else begin
            $display("FAIL: SLTU negative as unsigned");
            sltu_fail++;
        end

        // Another negative value test
        a = 32'd10; b = 32'hFFFFFFFF; sel = `SLTU;
        #10 $display("a=%d, b=%h (%d signed), a<b=%d (unsigned)", a, b, $signed(b), out);
        if (out == 32'd1) begin
            $display("PASS: SLTU unsigned comparison");
            sltu_pass++;
        end else begin
            $display("FAIL: SLTU unsigned comparison");
            sltu_fail++;
        end
// --------------------------------------------------------------------------------------------------
        total_pass = add_pass + sub_pass + xor_pass + or_pass + and_pass +
                    sll_pass + srl_pass + sra_pass + slt_pass + sltu_pass;
        total_fail = add_fail + sub_fail + xor_fail + or_fail + and_fail +
                    sll_fail + srl_fail + sra_fail + slt_fail + sltu_fail;
        $display("\n----- TEST SUMMARY -----");
        $display("ADD: %d passed, %d failed", add_pass, add_fail);
        $display("SUB: %d passed, %d failed", sub_pass, sub_fail);
        $display("XOR: %d passed, %d failed", xor_pass, xor_fail);
        $display("OR: %d passed, %d failed", or_pass, or_fail);
        $display("AND: %d passed, %d failed", and_pass, and_fail);
        $display("SLL: %d passed, %d failed", sll_pass, sll_fail);
        $display("SRL: %d passed, %d failed", srl_pass, srl_fail);
        $display("SRA: %d passed, %d failed", sra_pass, sra_fail);
        $display("SLT: %d passed, %d failed", slt_pass, slt_fail);
        $display("SLTU: %d passed, %d failed", sltu_pass, sltu_fail);
        $display("SUMMARY: %d passed, %d failed", total_pass, total_fail);

        $finish;
    end
endmodule
