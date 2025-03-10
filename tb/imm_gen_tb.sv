`include "imm_sel.vh"

module imm_gen_tb;
    logic [24:0] inst;
    logic [2:0] imm_sel;

    logic [31:0] out;

    imm_gen DUT (
        .inst       (inst),
        .imm_sel    (imm_sel),
        .out        (out)
    );

    integer i_pass = 0, i_fail = 0;
    integer s_pass = 0, s_fail = 0;
    integer b_pass = 0, b_fail = 0;
    integer u_pass = 0, u_fail = 0;
    integer j_pass = 0, j_fail = 0;
    integer total_pass = 0, total_fail = 0;

    // I-TYPE tests
    integer inst_addi_pos = 32'h00C48413;
    integer inst_addi_neg = 32'hFFC48413;
    // S-TYPE tests
    integer inst_sh_pos = 32'h00941823;
    integer inst_sh_neg = 32'hFE941E23;
    // B-TYPE tests
    integer inst_beq_pos = 32'h00A48E63;
    integer inst_beq_neg = 32'hFEA48863;
    // U-TYPE tests
    integer inst_lui = 32'h54321437;
    // J-TYPE tests
    integer inst_jal_pos = 32'h7FFFF0EF;
    integer inst_jal_neg = 32'h800000EF;

    initial begin
        $dumpfile("imm_gen_tb.vcd");
        $dumpvars(0, imm_gen_tb);

//-----------------------------------------I-TYPE------------------------------------
        // I-TYPE (postive immediate)
        // addi s0, s1, 12
        // Field Values (dec): imm[11:0] = 12, rs1 = x9, f3 = 0, rd = x8, op = 17
        // Machine Code: imm[11:0] = 0000 0000 1100, rs1 = 01001, f3 = 000, rd = 01000, op = 001 0011
        // Final 32-bit hex: 0x00C48413
        inst = inst_addi_pos[31:7]; imm_sel = `I_TYPE;
        #10;
        if (out == 32'd12) begin
            $display("PASS: Postive I_TYPE");
            i_pass++;
        end else begin
            $display("FAIL: Postive I_TYPE");
            $display("  Expected: %0d, Got: %0d", 32'd12, out);
            i_fail++;
        end
        // I-TYPE (negative immediate)
        // addi s0, s1, -4
        // Field Values (dec): imm[11:0] = -4, rs1 = x9, f3 = 0, rd = x8, op = 17
        // Machine Code: imm[11:0] = 1111 1111 1100, rs1 = 01001, f3 = 000, rd = 01000, op = 001 0011
        // Final 32-bit hex: 0xFFC48413
        inst = inst_addi_neg[31:7]; imm_sel = `I_TYPE;
        #10;
        if (out == -32'd4) begin
            $display("PASS: Negative I_TYPE");
            i_pass++;
        end else begin
            $display("FAIL: Negative I_TYPE");
            $display("  Expected: %0d, Got: %0d", $signed(-32'd4), $signed(out));
            i_fail++;
        end

//-----------------------------------------------------------------------------------

//-----------------------------------------S-TYPE------------------------------------
        // S-TYPE (positive immediate)
        // sh x9, 16(x8)
        // Field Values (dec): imm[11:5] = 0, imm[4:0] = 16, rs2 = x9, rs1 = x8, f3 = 2, op = 35
        // Machine Code: imm[11:5] = 000 0000, rs2 = 01001, rs1 = 01000, f3 = 001, imm[4:0] = 10000, op = 010 0011
        // Final 32-bit hex: 0x00941823
        inst = inst_sh_pos[31:7]; imm_sel = `S_TYPE;
        #10;
        if (out == 32'd16) begin
            $display("PASS: Postive S_TYPE");
            s_pass++;
        end else begin
            $display("FAIL: Postive S_TYPE");
            $display(" Expected: %0d, Got: %0d", 32'd16, out);
            s_fail++;
        end
        // S-TYPE (negative immediate)
        // sh x9, -4(x8)
        // Field Values (dec): imm[11:5] = 127, imm[4:0] = 28, rs2 = x9, rs1 = x8, f3 = 2, op = 35
        // Machine Code: imm[11:5] = 111 1111, rs2 = 01001, rs1 = 01000, f3 = 001, imm[4:0] = 11100, op = 010 0011
        // Final 32-bit hex: 0xFE941E23
        inst = inst_sh_neg[31:7]; imm_sel = `S_TYPE;
        #10;
        if (out == -32'd4) begin
            $display("PASS: Negative S_TYPE");
            s_pass++;
        end else begin
            $display("FAIL: Negative S_TYPE");
            $display(" Expected: %0d, Got: %0d", $signed(-32'd4), $signed(out));
            s_fail++;
        end

//-----------------------------------------------------------------------------------

//-----------------------------------------B-TYPE------------------------------------

        // B-TYPE (positive immediate)
        // beq x9, x10, 28
        // Field Values (dec): imm[12]=0, imm[10:5]=0, imm[4:1]=7, imm[11]=0, rs2=x10, rs1=x9, f3=0, op=99
        // Machine Code: imm[12,10:5]=000 0000, rs2=01010, rs1=01001, f3=000, imm[4:1,11]=0111 0, op=110 0011
        // Final 32-bit hex: 0x00A48E63
        inst = inst_beq_pos[31:7]; imm_sel = `B_TYPE;
        #10;
            if (out == 32'd28) begin
            $display("PASS: Basic B_TYPE");
            b_pass++;
        end else begin
            $display("FAIL: Basic B_TYPE");
            $display(" Expected: %0d, Got: %0d", 32'd28, out);
            b_fail++;
        end

        // B-TYPE (negative immediate)
        // beq x9, x10, -2064
        // Field Values (dec): imm[12]=1, imm[10:5]=63, imm[4:1]=4, imm[11]=0, rs2=x10, rs1=x9, f3=0, op=99
        // Machine Code: imm[12,10:5]=111 1111, rs2=01010, rs1=01001, f3=000, imm[4:1,11]=0100 0, op=110 0011
        // Final 32-bit hex: 0xFEA48863
        inst = inst_beq_neg[31:7]; imm_sel = `B_TYPE;
        #10;
        if (out == -32'd2064) begin
            $display("PASS: Negative B_TYPE");
            b_pass++;
        end else begin
            $display("FAIL: Negative B_TYPE");
            $display(" Expected: %0d, Got: %0d", $signed(-32'd2064), $signed(out));
            b_fail++;
        end

//-----------------------------------------------------------------------------------

//-----------------------------------------U-TYPE------------------------------------

        // U-TYPE
        // lui x8, 0x54321
        // 32-bit hex: 0x54321437
        inst = inst_lui[31:7]; imm_sel = `U_TYPE;
        #10;
        if (out == 32'h54321000) begin
            $display("PASS: U_TYPE");
            i_pass++;
        end else begin
            $display("FAIL: U_TYPE");
            $display(" Expected: %0h, Got: %0h", 32'h54321000, out);
            i_fail++;
        end

//-----------------------------------------------------------------------------------

//-----------------------------------------J-TYPE------------------------------------

        // J-TYPE (positive immediate)
        // jal x1, 1048574 (0xFFFFFC)
        // Field Values: imm[20]=0, imm[10:1]=0x3FF, imm[11]=0, imm[19:12]=0xFF, rd=x1, op=111
        // Machine Code: imm[20,10:1,11,19:12]=0 11 1111 1111 0 1111 1111, rd=00001, op=110 1111
        // Final 32-bit hex: 0x7FFFF0EF
        inst = inst_jal_pos[31:7]; imm_sel = `J_TYPE;
        #10;
        if (out == 32'd1048574) begin
            $display("PASS: Positive J_TYPE");
            j_pass++;
        end else begin
            $display("FAIL: Positive J_TYPE");
            $display(" Expected: %0d, Got: %0d", 32'd1048574, out);
            j_fail++;
        end

        // J-TYPE (negative immediate)
        // jal x1, -1048576 (0xFFF00000)
        // Field Values: imm[20]=1, imm[10:1]=0x000, imm[11]=0, imm[19:12]=0x00, rd=x1, op=111
        // Machine Code: imm[20,10:1,11,19:12]=1 00 0000 0000 0 0000 0000, rd=00001, op=110 1111
        // Final 32-bit hex: 0x800000EF
        inst = inst_jal_neg[31:7]; imm_sel = `J_TYPE;
        #10;
        if (out == -32'd1048576) begin
            $display("PASS: Negative J_TYPE");
            j_pass++;
        end else begin
            $display("FAIL: Negative J_TYPE");
            $display(" Expected: %0d, Got: %0d", $signed(-32'd1048576), $signed(out));
            j_fail++;
        end

//-----------------------------------------------------------------------------------
        total_pass = i_pass + s_pass + b_pass + u_pass + j_pass;
        total_fail = i_fail + s_fail + b_fail + u_fail + j_fail;
        $display("SUMMARY: %d passed, %d failed", total_pass, total_fail);

        $finish;
    end
endmodule
