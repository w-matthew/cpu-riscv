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
    // I-TYPE tests
    integer inst_addi_pos = 32'h00C48413;
    integer inst_addi_neg = 32'hFFC48413;
    // S-TYPE tests
    integer inst_sh_pos = 32'h00941823;
    integer inst_sh_neg = 32'hFE941E23;

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



        $finish;
    end
endmodule
