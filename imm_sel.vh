/*
    ifndef checks whether IMM_SEL has been defined, and if not, we proceed to define IMM_SEL
*/
`ifndef IMM_SEL
`define IMM_SEL

// Define instruction type, using 3 bits to represent a total of 6 instruction types (000 - R, 001 - I, etc.)
`define R_TYPE 3'd0
`define I_TYPE 3'd1
`define S_TYPE 3'd2
`define B_TYPE 3'd3
`define U_TYPE 3'd4
`define J_TYPE 3'd5

`endif
