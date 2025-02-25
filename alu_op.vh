/*
    ifndef checks whether alu_op has been defined, and if not, we proceed to define alu_op
*/
`ifndef ALU_OP
`define ALU_OP

// Can also represent ADD as 4'b0000, useful to have a verilog header file for readability.
`define ADD 4'd0
`define SUB 4'd1
`define XOR 4'd2
`define OR 4'd3
`define AND 4'd4
`define SLL 4'd5
`define SRL 4'd6
`define SRA 4'd7
`define SLT 4'd8
`define SLTU 4'd9

`endif
