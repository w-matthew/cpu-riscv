/*
    ifndef checks whether IMM_SEL has been defined, and if not, we proceed to define IMM_SEL
*/
`ifndef IMM_SEL
`define IMM_SEL

// Define instruction type, using 3 bits to represent a total of 6 instruction types (000 - I, etc.)
`define I_TYPE 3'd0
`define S_TYPE 3'd1
`define B_TYPE 3'd2
`define U_TYPE 3'd3
`define J_TYPE 3'd4

`endif
