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
    integer inst_32 = 32'h00C48413;

    initial begin
        $dumpfile("imm_gen_tb.vcd");
        $dumpvars(0, imm_gen_tb);

        // I-TYPE (postive immediate)
        // addi s0, s1, 12
        // Field Values: imm[11:0] = 12, rs1 = 9, f3 = 0, rd = 8, op = 17
        // Machine Code: imm[11:0] = 0000 0000 1100, rs1 = 01001, f3 = 000, rd = 01000, op = 001 0011
        // Final 32-bit hex: 0x00C48413
        inst = inst_32[31:7]; imm_sel = `I_TYPE;
        #10;
        if (out == 32'd12) begin
            $display("PASS: Basic I_TYPE");
            i_pass++;
        end else begin
            $display("FAIL: Basic I_TYPE");
            $display("  Expected: %0d, Got: %0d", 32'd12, out);
            i_fail++;
        end

        $finish;
    end
endmodule
