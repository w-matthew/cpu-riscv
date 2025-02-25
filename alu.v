`include "alu_op.vh"

module alu (
    // 32-bit system, reflected in inputs
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] sel,

    // Must specify the variable type (input, output, inout)
    output reg [31:0] out
);

    // always @(*) is used for conditional circuits, where the output is updated as soon as there is a change in input. always @(posedge clk) is used for sequential circuits, where the output is only updated at the postive edge of the clock cycle
    always @(*) begin
        case (sel)
            // add
            `ADD: out = a + b;
            // sub
            `SUB: out = a - b;
            // xor
            `XOR: out = a ^ b;
            // or
            `OR: out = a | b;
            // and
            `AND: out = a & b;
            // sll - shift left logical
            `SLL: out = a << b[4:0];
            // srl - shift right logical
            `SRL: out = a >> b[4:0];
            // sra - shift right arithmetic
            `SRA: out = $signed(a) >>> b[4:0];
            // slt - set if less than (signed)
            `SLT: out = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            // sltu - set if less than (unsigned)
            `SLTU: out = (a < b) ? 32'd1 : 32'd0;
            // default case to prevent latches
            default: out = 32'd0;

        endcase;
    end

endmodule
