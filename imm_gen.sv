`include "imm_sel.vh"

module imm_gen (
    // following datapath, only top 25 bits of full 32 bit instruction fed in (i.e. 32_inst[31:7])
    input wire [24:0] inst,
    input wire [2:0] imm_sel,

    output reg [31:0] out
);

    always @(*) begin
        case (imm_sel)
            `I_TYPE: out = {{21{inst[24]}}, inst[23:18], inst[17:14], inst[13]};
            `S_TYPE: out = {{21{inst[24]}}, inst[23:18], inst[4:1], inst[0]};
            `B_TYPE: out = {{20{inst[24]}}, inst[0], inst[23:18], inst[4:1], 1'b0};
            `U_TYPE: out = {inst[24], inst[23:13], inst[12:5], 12'b0};
            `J_TYPE: out = {{12{inst[24]}}, inst[12:5], inst[13], inst[23:18], inst[17:14], 1'b0};
            default: out = 32'b0; // Add default case for completeness
        endcase
    end
endmodule
